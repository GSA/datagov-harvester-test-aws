
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
