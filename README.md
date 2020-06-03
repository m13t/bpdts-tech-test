# BPDTS Tech Test as Lambda through API Gateway

## Deploying the application

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

## Performance Test

Benchmarking 92hlxl13mf.execute-api.eu-west-2.amazonaws.com (be patient)
Completed 10000 requests
Completed 20000 requests
Completed 30000 requests
Completed 40000 requests
Completed 50000 requests
Completed 60000 requests
Completed 70000 requests
Completed 80000 requests
Completed 90000 requests
Completed 100000 requests
Finished 100000 requests


Server Software:        
Server Hostname:        92hlxl13mf.execute-api.eu-west-2.amazonaws.com
Server Port:            443
SSL/TLS Protocol:       TLSv1.2,ECDHE-RSA-AES128-GCM-SHA256,2048,128
Server Temp Key:        ECDH P-256 256 bits
TLS Server Name:        92hlxl13mf.execute-api.eu-west-2.amazonaws.com

Document Path:          /
Document Length:        3802 bytes

Concurrency Level:      50
Time taken for tests:   87.523 seconds
Complete requests:      100000
Failed requests:        0
Keep-Alive requests:    100000
Total transferred:      397900000 bytes
HTML transferred:       380200000 bytes
Requests per second:    1142.55 [#/sec] (mean)
Time per request:       43.762 [ms] (mean)
Time per request:       0.875 [ms] (mean, across all concurrent requests)
Transfer rate:          4439.67 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0  10.5      0     863
Processing:    27   43  16.2     41     951
Waiting:       27   43  16.2     41     951
Total:         27   44  19.8     41    1566

Percentage of the requests served within a certain time (ms)
  50%     41
  66%     44
  75%     47
  80%     50
  90%     54
  95%     57
  98%     62
  99%     66
 100%   1566 (longest request)
