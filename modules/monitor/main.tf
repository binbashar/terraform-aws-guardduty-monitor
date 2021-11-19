module "lambda" {
  source  = "github.com/binbashar/terraform-aws-lambda-1.git?ref=v2.5.0"

  runtime = "nodejs14.x"

  source_dir  = "${path.module}/src"
  output_dir = "${path.module}/build/lambda.zip"

  name      = var.name
  role_name = var.role_name

  timeout               = 900
  log_retention_in_days = 90

  environment = {
    SLACK_NOTIFICATION_URL = var.slack_notification_url
  }
}
