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
    PARAMETER_NAME                         = var.slack_notification_url != null ? aws_ssm_parameter.lambda_ssm_parameter[0].name : (var.slack_notification_url_ssm_name != null ? var.slack_notification_url_ssm_name : null)
    PARAMETER_ENCRYPTED                    = var.slack_notification_url != null ? "true" : (var.slack_notification_url_ssm_name != null ? var.slack_notification_url_ssm_encrypted : null)
    SECRET_ARN                             = var.slack_notification_url_secret_arn != null ? var.slack_notification_url_secret_arn : null
    SECRET_KEY                             = var.slack_notification_url_secret_arn != null ? var.slack_notification_url_secret_key : null
    PARAMETERS_SECRETS_EXTENSION_HTTP_PORT = var.parameters_secrets_extension_http_port
    PARAMETERS_SECRETS_EXTENSION_LOG_LEVEL = var.parameters_secrets_extension_log_level
    SSM_PARAMETER_STORE_TTL                = var.ssm_parameter_store_ttl
    SECRETS_MANAGER_TTL                    = var.secrets_manager_ttl
  }
}

resource "aws_ssm_parameter" "lambda_ssm_parameter" {
  count = var.slack_notification_url != null ? 1 : 0

  name  = "/${var.name}-slack-url"
  type  = "SecureString"
  value = var.slack_notification_url
}

resource "aws_iam_role_policy" "lambda_ssm_parameter" {
  count = var.slack_notification_url != null ? 1 : 0

  name = "ssm-parameter-policy"
  role = module.lambda.role_name

  policy = data.aws_iam_policy_document.lambda_ssm_parameter[0].json
}

data "aws_iam_policy_document" "lambda_ssm_parameter" {
  count = var.slack_notification_url != null ? 1 : 0

  statement {
    sid       = ""
    effect    = "Allow"
    resources = [aws_ssm_parameter.lambda_ssm_parameter[0].arn]
    actions   = ["ssm:GetParameter", "kms:Decrypt"]
  }

}

resource "aws_iam_role_policy" "lambda_secret_manager" {
  count = var.slack_notification_url_secret_arn != null ? 1 : 0

  name = "secret-manager-policy"
  role = module.lambda.role_name

  policy = data.aws_iam_policy_document.lambda_secret_manager[0].json
}

data "aws_iam_policy_document" "lambda_secret_manager" {
  count = var.slack_notification_url_secret_arn != null ? 1 : 0

  statement {
    sid       = ""
    effect    = "Allow"
    resources = [var.slack_notification_url_secret_arn]
    actions   = ["secretsmanager:GetSecretValue"]
  }
}

data "aws_ssm_parameter" "ssm_provided" {
  count = var.slack_notification_url_ssm_name != null ? 1 : 0

  name = var.slack_notification_url_ssm_name
}

resource "aws_iam_role_policy" "ssm_provided" {
  count = var.slack_notification_url_ssm_name != null ? 1 : 0

  name = "secret-manager-policy"
  role = module.lambda.role_name

  policy = data.aws_iam_policy_document.ssm_provided[0].json
}

data "aws_iam_policy_document" "ssm_provided" {
  count = var.slack_notification_url_ssm_name != null ? 1 : 0

  statement {
    sid       = ""
    effect    = "Allow"
    resources = [data.aws_ssm_parameter.ssm_provided[0].arn]
    actions   = ["ssm:GetParameter", "kms:Decrypt"]
  }
}

output "test" {
  value = var.slack_notification_url_ssm_name
}