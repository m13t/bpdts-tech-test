# BPDTS Tech Test as Lambda through API Gateway

Deploying the application

Prerequisites:
* an AWS account
* Terraform >= 0.12.x
* Python >= 3.7
* setup_tools
* pip

First the application needs patching to work with AWS API Gateway

```shell
$ git apply --directory=app lambda.patch
```

Now we need to install the required libraries that the application needs.
We'll install these into a separate directory so that we can pick these
up and add these as a Lambda Layer.

```shell
$ pip3 install -r app/requirements.txt --target layers/python
```

Now the application is patched and the dependencies have been pulled,
we will initialize Terraform to install the required providers.

```shell
$ terraform init
```

Once Terraform has been initialized we can run an apply to provision the
API Gateway, Lambda Function, Lambda Layer and the required permissions.

```shell
$ terraform apply
```

Once Terraform has finished the apply run, it will output the endpoint
that has been published to connect to the API Gateway. If you've missed
this, you can always run `terraform output endpoint` to find it again.
