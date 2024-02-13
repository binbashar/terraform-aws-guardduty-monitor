module "lambda" {
  source = "github.com/binbashar/terraform-aws-lambda-1.git?ref=v2.5.10"

  runtime = "nodejs14.x"
  layers  = ["arn:aws:lambda:us-east-1:177933569100:layer:AWS-Parameters-and-Secrets-Lambda-Extension:11"]

  source_dir = "${path.module}/src"
  output_dir = "${path.module}/build/lambda.zip"

  name      = var.name
  role_name = var.role_name

  timeout               = 900
  log_retention_in_days = 90

  environment = {
    SLACK_NOTIFICATION_URL = var.slack_notification_url
  }
}

resource "aws_iam_role_policy" "lambda_secret_manager" {
  name = "secret-manager-policy"
  role = module.lambda.role_name

  policy = data.aws_iam_policy_document.lambda_secret_manager[0].json
}

data "aws_iam_policy_document" "lambda_secret_manager" {
  statement {
    sid       = ""
    effect    = "Allow"
    resources = [var.slack_notification_url]
    actions   = ["secretsmanager:GetSecretValue"]
  }
}
