provider "aws" {
  region = "eu-west-2"
}

locals {
  payload_path = format("%s/payload.zip", path.module)
  layers_path  = format("%s/layer.zip", path.module)
}

data "archive_file" "app" {
  type        = "zip"
  output_path = local.payload_path
  source_dir  = "app"
}

data "archive_file" "layer" {
  type        = "zip"
  output_path = local.layers_path
  source_dir  = "layers"
}

data "aws_iam_policy_document" "lambda_assume" {
  statement {
    effect = "Allow"

    principals {
      type = "Service"

      identifiers = [
        "lambda.amazonaws.com"
      ]
    }

    actions = [
      "sts:AssumeRole"
    ]
  }
}

resource "aws_iam_role" "lambda" {
  name               = "bpdts-app-lambda"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume.json
}

resource "aws_iam_role_policy_attachment" "lambda" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_layer_version" "lambda_layer" {
  filename   = local.layers_path
  layer_name = "bpdts-flask-libs"

  compatible_runtimes = [
    "python3.7",
  ]
}

// Upload our Lambda function code.
resource "aws_lambda_function" "app" {
  function_name = "bpdts-flask"
  handler       = "app.lambda_handler"
  runtime       = "python3.7"

  filename         = local.payload_path
  source_code_hash = filebase64sha256(local.payload_path)

  layers = [
    aws_lambda_layer_version.lambda_layer.arn,
  ]

  role = aws_iam_role.lambda.arn
}

// Create a new HTTP API Gateway. This will use the `quick create` method
resource "aws_apigatewayv2_api" "app" {
  name          = "bpdts-flask"
  protocol_type = "HTTP"
}

resource "aws_lambda_permission" "lambda_permission" {
  function_name = aws_lambda_function.app.function_name

  action    = "lambda:InvokeFunction"
  principal = "apigateway.amazonaws.com"

  // Allow the API Gateway to call any path and method on our default stage
  source_arn = format("%s/*/$default", aws_apigatewayv2_api.app.execution_arn)
}

resource "aws_apigatewayv2_integration" "app" {
  api_id = aws_apigatewayv2_api.app.id

  // Proxy all requests to our Lambda function
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
  integration_uri    = aws_lambda_function.app.invoke_arn

  // AWSGI which is wrapping the Python Flask app doesn't
  // work with API Gateway v2 format, so ensure we're using V1
  payload_format_version = "1.0"

  lifecycle {
    ignore_changes = [
      // Despite this only being used by WebSocket gateway type,
      // terraform seems to want to set this, which constantly results
      // in a diff failure and a wanting to send new changes. Ignore!
      passthrough_behavior
    ]
  }
}

resource "aws_apigatewayv2_route" "default" {
  api_id    = aws_apigatewayv2_api.app.id
  route_key = "$default"
  target    = format("integrations/%s", aws_apigatewayv2_integration.app.id)
}

// This resource will fail on subsequent apply runs due to a bug in the
// AWS provider. At the time of writing this has been fixed in PR#12904
// and scheduled for release in v2.65.0
resource "aws_apigatewayv2_stage" "default" {
  api_id = aws_apigatewayv2_api.app.id

  name        = "$default"
  auto_deploy = true

  lifecycle {
    ignore_changes = [
      // We're automatically deploying to this stage so
      // don't care if this changes, we expect it to.
      // Should also be fixed in v2.65.0
      deployment_id,

      // See resource comment
      default_route_settings
    ]
  }
}
