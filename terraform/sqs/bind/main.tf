
variable "name" {
  type        = string
  description = "Unique ID to separate sqs instances"
}

variable "sqs_arn" {
  type        = string
  description = "ARN of SQS Resource"
}

output "sqs_arn" {
  value = var.sqs_arn
}
