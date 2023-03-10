
variable "name" {
  type        = string
  description = "Unique ID to separate lambda functions"
}

variable "script" {
  type        = string
  description = "Python code to execute"
}

variable "sqs_input" {
  type        = string
  description = "SQS ARN to trigger lamdba function"
}

variable "s3_AWS_ACCESS_KEY_ID" {
  type        = string
  description = "S3"
}

variable "s3_AWS_SECRET_ACCESS_KEY" {
  type        = string
  description = "S3"
}

variable "s3_AWS_DEFAULT_REGION" {
  type        = string
  description = "S3"
}

variable "s3_BUCKET_NAME" {
  type        = string
  description = "S3"
}
