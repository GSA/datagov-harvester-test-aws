#!/bin/bash

# set -e

SERVICE_SQS='b6850430-71bd-4096-9f75-e395524e7b73'
PLAN_SQS='4c0c7e5e-9f86-47be-aaed-29ae9adf7c49'
SERVICE_LAMBDA='a1fa5f24-ed73-48e8-a99f-14906728b945'
PLAN_LAMBDA='4d7f0501-77d6-4d21-a37a-8b80a0ea9c0d'

instance_name=demo-test3

script=""
while IFS= read -r line; do
  script="${script}\n${line}"
done < test.py



echo "Creating S3 Bucket: $instance_name-s3"
cf service "$instance_name-s3" > /dev/null 2>&1 || cf create-service s3 basic-public "$instance_name-s3"
cf service-key "$instance_name-s3" "key" &> /dev/null || cf create-service-key "$instance_name-s3" "key"
S3_CREDENTIALS=`cf service-key "$instance_name-s3" "key" | tail -n +2`
AWS_ACCESS_KEY_ID=`echo "${S3_CREDENTIALS}" | jq -r .credentials.access_key_id`
AWS_SECRET_ACCESS_KEY=`echo "${S3_CREDENTIALS}" | jq -r .credentials.secret_access_key`
BUCKET_NAME=`echo "${S3_CREDENTIALS}" | jq -r .credentials.bucket`
AWS_DEFAULT_REGION=`echo "${S3_CREDENTIALS}" | jq -r '.credentials.region'`

echo "Creating SQS Instance: $instance_name-sqs"
binding="binding-`date +%s`"
SERVICE_ID=$SERVICE_SQS PLAN_ID=$PLAN_SQS INSTANCE_NAME="$instance_name-sqs" SERVICE_NAME='sqs' PLAN_NAME='base' BIND_NAME=$binding  make demo-up

sqs_arn="`cat "$instance_name-sqs.binding.json" | jq -r .credentials.sqs_arn`"
echo $sqs_arn
echo "Creating Lambda Function: $instance_name-lambda"
provisions="'{ \"sqs_input\": \"${sqs_arn}\", \"script\": \"${script}\" }'"
echo $provisions
SERVICE_ID=$SERVICE_LAMBDA PLAN_ID=$PLAN_LAMBDA INSTANCE_NAME="$instance_name-lambda" SERVICE_NAME='lambda' PLAN_NAME='base' BIND_NAME=$binding  CLOUD_PROVISION_PARAMS=$provisions make demo-up


if [[ $DESTROY -eq 1 ]]; then
  echo "Destroying Lambda Function: $instance_name-lambda"
  SERVICE_ID=$SERVICE_LAMBDA PLAN_ID=$PLAN_LAMBDA INSTANCE_NAME="$instance_name-lambda" SERVICE_NAME='lambda' PLAN_NAME='base' BIND_NAME=$binding  make demo-down
  echo "Destroying SQS Instance: $instance_name-sqs"
  SERVICE_ID=$SERVICE_SQS PLAN_ID=$PLAN_SQS INSTANCE_NAME="$instance_name-sqs" SERVICE_NAME='sqs' PLAN_NAME='base' BIND_NAME=$binding  make demo-down
fi
