# Test Submission

This repository serves as my completed submission for the BPDTS DevOps Technical Test.

## What I've Done

Upon looking at the application, it's functionality and it's requirements, I have decided to deploy the application to AWS using API Gateway and Lambda, making it an entirely serverless deployment. As the application
is stateless and provides all the data stored within it from a static JSON file, it seemed suitable from both performance and cost-efficiency view points.

Using a serverless model will allow a substantial amount of scalability with very little forethought given there are no servers to manage, no scaling policies to apply and no forecasting of potential cost growth. Updating
the application is made simple by way of just updating the code and redeploying the Lambda.

The application, in its current state within the source repository, does not natively support running inside AWS Lambda as it does not detect the runtime request context made available by Lambda. A quick bit of research
provided me with the AWSGI wrapper package, which I have injected into the application by way of patch. This simply wraps the Flask application inside a function that handles the Lambda context, but without a need to
update the original application repository.

# What Else Would I Do?

Clearly this is not an application intended for any grand purpose, however, that's not to say we can't have grand plans for it. If this was an application that was given to me to support, maintain and improve, then there
are certainly some additions I would likely make. These are as follows:

1. Lambda and API Gateway, as good as they are do have some levels of latency when the function is cold - that is to say it's not idling in memory within the Lambda infrastructure. This can have the appearance of requests
   appearing to have a relatively slow first response. Give then nature of the application is fairly static, as well as the endpoints all being GET requests, it would be an ideal candidate for placing a CDN like CloudFront in front of it. A CDN would greatly reduce the latency of these requests, especially with the option for delivery from edge locations.
2. Offload the data to a database. The application currently has a static data set that is loaded in to memory when the application is loaded. Whilst a static dataset serves the simple purpose of this API, it would not be
   considered a good practice to have the data inline with the application. Following in the serverless appraoch I have already set out, I would recommend loading this dataset in to AWS DynamoDB and have the application load
   that data from there instead. This approach would lessen the burden of constant changes to the application when the data needs to change, which in turn would have the cost of additional deployments, which shouldn't be needed
   just because of a change to the data. This might not mean the response would be as quick serving from an external service like DynamoDB when compared to an in-memory store, but let's not forget we've got the caching from step
   one to help out there. We also benefit from the scalability and cost of using DynamoDB over something like RDS or a Mongo cluster.
3. I would consider the current state of this deployment to be a good foundation for DevOps good practice, as we're building everything as code. Infrastructure as code would mean reliable and consistent deployments, but there's
   still a fair amount of human interaction required in order to actually deploy this. As an example, there are multiple versions of Terraform, with differing versions of different providers, all of which could introduce their
   own unknown factors across the different versions. Pinning these versions down would be a good addition to the Terraform code.
4. Automating a build, test and deployment pipeline would also lessen the human element and ensure a consistent delivery mechanism. Ideally we would be testing the Terraform code, deploying the API to a new stage, testing that
   stage and then making it live if the tests are successful. This approach would ensure that we have confidence in the what we are delivering before we make it live, reducing the risk of failure in a live service.

There are many additional things that I would consider doing too, but in the spirit of Agile, I hope the above would suffice as a first itteration.


# Test Submission

This repository serves as my completed submission for the BPDTS DevOps Technical Test.

## What I've Done

Upon looking at the application, it's functionality, and it's requirements, I have decided to deploy the application to AWS using API Gateway and Lambda, making it an entirely serverless deployment. As the application
is stateless and provides all the data stored within it from a static JSON file, it seemed suitable from both performance and cost-efficiency viewpoints.

Using a serverless model will allow a substantial amount of scalability with minimal forethought given there are no servers to manage, no scaling policies to apply and no forecasting of potential cost growth. Updating
the application is made simple by way of just updating the code and redeploying the Lambda.

The application, in its current state within the source repository, does not natively support running inside AWS Lambda as it does not detect the runtime request context made available by Lambda. A quick bit of research
provided me with the AWSGI wrapper package, which I have injected in to the application by way of a patch. This patch wraps the Flask application inside a function that handles the Lambda context, but without a need to
update the original application repository.

# What Else Would I Do?

Clearly, this is not an application intended for any grand purpose; however, that's not to say we can't have ambitious plans for it. If this was an application that was given to me to support, maintain and improve, then there
are certainly some additions I would likely make. These are as follows:

1. Lambda and API Gateway, as good as they are do have some levels of latency when the function is cold - that is to say, it's not idling in memory within the Lambda infrastructure. Cold functions can have the appearance of
   requests appearing to have a relatively slow first response. Give then nature of the application is relatively static, as well as the endpoints all being GET requests, it would be an ideal candidate for placing a CDN like
    CloudFront in front of it. A CDN would significantly reduce the latency of these requests, especially with the option for delivery from edge locations.
2. Offload the data to a database. The application currently has a static data set that is loaded into memory when the application is loaded. While a static dataset serves the simple purpose of this API, it would not be considered
   a good practice to have the data inline with the application. Following in the serverless approach, I have already set out; I would recommend loading this dataset into AWS DynamoDB and have the application load that data from
   there instead. This approach would lessen the burden of constant changes to the application when the data needs to change, which in turn would have the cost of additional deployments, which shouldn't be required just because of
   a change to the data. This change might not mean the response would be as quick serving from an external service like DynamoDB when compared to an in-memory store, but let's not forget we've got the caching from step one to
   help out there. We also benefit from the scalability and cost of using DynamoDB over something like RDS or a Mongo cluster.
3. I would consider the current state of this deployment to be a good foundation for DevOps good practice, as we're building everything as code. Infrastructure as code would mean reliable and consistent deployments, but there's
   still a fair amount of human interaction required to actually deploy this. As an example, there are multiple versions of Terraform, with differing versions of different providers, all of which could introduce their own unknown
   factors across the different versions. Pinning these versions down would be an excellent addition to the Terraform code.
4. Automating a build, test and deployment pipeline would also lessen the human element and ensure a consistent delivery mechanism. Ideally, we would be testing the Terraform code, deploying the API to a new stage, testing that
   stage and then making it live if the tests are successful. This approach would ensure that we have confidence in what we are delivering before we make it live, reducing the risk of failure in a live service.

There are many additional things that I would consider doing too, but in the spirit of Agile, I hope the above would suffice as a first iteration.
