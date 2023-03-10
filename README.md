# datagov-brokerpak-harvester

## Why this project

This is a [cloud-service-broker](https://github.com/pivotal/cloud-service-broker) plugin that makes services
needed by the data.gov team brokerable via the [Open Service Broker
API](https://www.openservicebrokerapi.org/) (compatible with Cloud Foundry and
Kubernetes), using Terraform.

For more information about the brokerpak concept, here's a [5-minute lightning
talk](https://www.youtube.com/watch?v=BXIvzEfHil0) from the 2019 Cloud Foundry Summit. You may also want to check out the brokerpak
[introduction](https://github.com/pivotal/cloud-service-broker/blob/master/docs/brokerpak-intro.md)
and
[specification](https://github.com/pivotal/cloud-service-broker/blob/master/docs/brokerpak-specification.md)
docs.

Huge props go to @josephlewis42 of Google for publishing and publicizing the
brokerpak concept, and to the Pivotal team running with the concept!

## Prerequisites

1. `make` is used for executing docker commands in a meaningful build cycle.
1. `jq` is used for running certain tests
1. [Docker Desktop (for Mac or
   Windows)](https://www.docker.com/products/docker-desktop) or [Docker Engine
   (for Linux)](https://www.docker.com/products/container-runtime) is used for  building, serving, and testing the brokerpak.
1. [`terraform` 1.1.5](https://releases.hashicorp.com/terraform/1.1.5/) is used for local development.
1. AWS account credentials (as environment variables) are used for actual service provisioning. The corresponding user must have at least the permissions described in permission-policies.tf. Set at least these variables:
    - AWS_ACCESS_KEY_ID
    - AWS_SECRET_ACCESS_KEY
    - AWS_DEFAULT_REGION

## For the Demo:
1. Ensure `ssb-development` AWS Credentials are set up.
1. Start broker
    ```bash
    make clean build up
    ```
1. Create demo infrastructure
    ```bash
    ./test.sh
    ```
1. Log into AWS Console (`ssb-development`) and go to `SQS` to send a test message.
1. Export cloud.gov S3 Credentials to inspect exported data
    ```bash
    aws s3 ls s3://${BUCKET_NAME}/raw/
    aws s3 ls s3://${BUCKET_NAME}/clean/
    ```
1. Destroy demo infrastructure.
    ```bash
    DESTROY=1 ./test.sh
    ```

## Contributing

See [CONTRIBUTING](CONTRIBUTING.md) for additional information.

## Public domain

This project is in the worldwide [public domain](LICENSE.md). As stated in [CONTRIBUTING](CONTRIBUTING.md):

> This project is in the public domain within the United States, and copyright and related rights in the work worldwide are waived through the [CC0 1.0 Universal public domain dedication](https://creativecommons.org/publicdomain/zero/1.0/).
>
> All contributions to this project will be released under the CC0 dedication. By submitting a pull request, you are agreeing to comply with this waiver of copyright interest.

