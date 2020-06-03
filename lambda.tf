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
