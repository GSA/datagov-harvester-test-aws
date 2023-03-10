
variable "sqs_arn" {
  type        = string
  description = "ARN of SQS Resource"
}

output "sqs_arn" {
  value = var.sqs_arn
}
