
resource "aws_sqs_queue" "main_queue" {
  name                      = "${var.name}-queue"
  delay_seconds             = 2
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 3

  tags = {
    Environment = "production"
  }
}
