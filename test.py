import datetime
import os
import boto3


def send_to_s3(prefix, message):
    id = os.environ.get("S3_AWS_ACCESS_KEY_ID")
    key = os.environ.get("S3_AWS_SECRET_ACCESS_KEY")
    region = os.environ.get("S3_AWS_DEFAULT_REGION")
    bucket_name = os.environ.get("S3_BUCKET_NAME")

    s3 = boto3.client("s3",
                      aws_access_key_id=id,
                      aws_secret_access_key=key,
                      region_name=region
                      )
    key = f"{prefix}input-" + datetime.datetime.now().strftime("%Y-%m-%d-%H:%M:%S") + ".json"  # NOQA E501
    s3.put_object(Bucket=bucket_name, Key=key, Body=f"input content here: {message}")  # NOQA E501


def handler(event, context):
    for record in event["Records"]:
        payload = str(record["body"])
        if "raw" in payload:
            send_to_s3("raw/", payload)
        else:
            send_to_s3("clean/", payload)
