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

Run the `make` command by itself for information on the various targets that are available. 

```bash
$ make
clean      Bring down the broker service if it is up and clean out the database
build      Build the brokerpak(s)
up         Run the broker service with the brokerpak configured. The broker listens on `0.0.0.0:8080`. curl http://127.0.0.1:8080 or visit it in your browser. 
down       Bring the cloud-service-broker service down
test       Execute the brokerpak examples against the running broker (TODO)
k8s-demo-up    Provision a SolrCloud instance and output the bound credentials
k8s-demo-down  Clean up data left over from tests and demos
ecs-demo-up    Provision a Solr standalone instance (configured for ckan) and output the bound credentials
ecs-demo-down  Clean up data left over from tests and demos
kind-up    Set up a local Kubernetes test environment using KinD
kind-down  Tear down the Kubernetes test environment in KinD
all        Clean and rebuild, start test environment, run the broker, run the examples, and tear the broker and test env down
help       This help
```

Notable targets are described below.

## Iterating on the Terraform code

To work with the Terraform and target cluster directly (eg not through the CSB or brokerpak), you can generate an appropriate .tfvars file by running:

```bash
make .env
```

From that point on, you can `cd terraform/provision` and iterate with `terraform init/plan/apply/etc`. The same configuration is also available in `terraform/bind`.

(Note if you've been working with the broker the configuration will probably already exist.)

## Building and starting the brokerpak (while the test environment is available)

Run

```bash
make build up 
```

The broker will start and (after about 40 seconds) listen on `0.0.0.0:8080`. You
test that it's responding by running:

```bash
curl -i -H "X-Broker-API-Version: 2.16" http://user:pass@127.0.0.1:8080/v2/catalog
```

In response you will see a YAML description of the services and plans available
from the brokerpak.

(Note that the `X-Broker-API-version` header is [**required** by the OSBAPI
specification](https://github.com/openservicebrokerapi/servicebroker/blob/master/spec.md#headers).
The broker will reject requests that don't include the header with `412
Precondition Failed`, and browsers will show that status as `Not Authorized`.)

You can also inspect auto-generated documentation for the brokerpak's offerings
by visiting [`http://127.0.0.1:8080/docs`](http://127.0.0.1:8080/docs) in your browser.

### Testing manually

Run

```bash
docker-compose exec -T broker /bin/cloud-service-broker client help"
```

to get a list of available commands. You can further request help for each
sub-command. Use this command to poke at the browser one request at a time.

For example to see the catalog:

```bash
docker-compose exec -T broker /bin/cloud-service-broker client catalog"
```

...and so on.

## Iterating on the brokerpak itself

To rebuild the brokerpak and launch it, then provision a test instance:

```bash
make down build up demo-up
# Poke and prod 
make demo-down down
```

## Tearing down the brokerpak

Run

```bash
make down
```

The broker will be stopped.

## Cleaning out the current state

Run

```bash
make clean
```

The broker image, database content, and any built brokerpak files will be removed.

## Contributing

See [CONTRIBUTING](CONTRIBUTING.md) for additional information.

## Public domain

This project is in the worldwide [public domain](LICENSE.md). As stated in [CONTRIBUTING](CONTRIBUTING.md):

> This project is in the public domain within the United States, and copyright and related rights in the work worldwide are waived through the [CC0 1.0 Universal public domain dedication](https://creativecommons.org/publicdomain/zero/1.0/).
>
> All contributions to this project will be released under the CC0 dedication. By submitting a pull request, you are agreeing to comply with this waiver of copyright interest.

