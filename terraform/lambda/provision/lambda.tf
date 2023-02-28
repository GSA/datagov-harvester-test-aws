
resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_solr_${var.name}_restarts"

  assume_role_policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "lambda.amazonaws.com"
        },
        "Effect": "Allow"
      }
    ]
  }
  EOF
}

resource "aws_iam_role_policy_attachment" "lambda_operations" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_operations.arn
}

resource "aws_iam_policy" "lambda_operations" {
  name        = "solr-${var.name}-lambda_operations"
  path        = "/"
  description = "IAM policy for logging/ecs-restarts from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ecs:*"
      ],
      "Resource": "*"
    },
    {
       "Effect": "Allow",
       "Action": [
         "sqs:SendMessage",
         "sqs:ReceiveMessage",
         "sqs:DeleteMessage",
         "sqs:GetQueueAttributes"
       ],
       "Resource": [ "${var.sqs_input}" ]
    }
  ]
}
EOF
}

resource "local_file" "main_app" {
  content  = var.script
  filename = "${path.module}/main.py"
}

resource "null_resource" "python_deployment" {
  provisioner "local-exec" {
    interpreter = ["/bin/sh", "-c"]
    command = <<-EOF
      zip -g deployment.zip main.py
    EOF
  }

  depends_on = [
    local_file.main_app
  ]
}

resource "aws_lambda_function" "main_lambda" {
  function_name = "harvester-${var.name}"
  role          = aws_iam_role.iam_for_lambda.arn
  runtime       = "python3.9"
  filename      = "deployment.zip"
  handler       = "main.handler"

  package_type = "Zip"
  depends_on = [
    null_resource.python_deployment
  ]
}

resource "aws_lambda_event_source_mapping" "sqs_main" {
  event_source_arn = var.sqs_input
  function_name    = aws_lambda_function.main_lambda.arn
}

resource "aws_cloudwatch_log_group" "lambda-restarts" {
  name              = "/aws/lambda/harvester-${var.name}"
  retention_in_days = 14
}
