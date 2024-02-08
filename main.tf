module "monitor" {
  source = "./modules/monitor"

  name      = var.monitor_name
  role_name = var.monitor_role_name

  slack_notification_url = var.monitor_slack_notification_url

  slack_notification_url_secret_arn = var.slack_notification_url_secret_arn
  slack_notification_url_secret_key = var.slack_notification_url_secret_key

  slack_notification_url_ssm_name      = var.slack_notification_url_ssm_name
  slack_notification_url_ssm_encrypted = var.slack_notification_url_ssm_encrypted

  ssm_parameter_store_ttl                = var.ssm_parameter_store_ttl
  secrets_manager_ttl                    = var.secrets_manager_ttl
  parameters_secrets_extension_log_level = var.parameters_secrets_extension_log_level
  parameters_secrets_extension_http_port = var.parameters_secrets_extension_http_port
}

resource "aws_cloudwatch_event_rule" "main" {
  name = var.event_rule_name

  event_pattern = <<EOF
{
  "source": [
    "aws.guardduty"
  ],
  "detail-type": [
    "GuardDuty Finding"
  ]
}
EOF
}

resource "aws_cloudwatch_event_target" "main" {
  rule = aws_cloudwatch_event_rule.main.name
  arn  = module.monitor.arn
}

resource "aws_lambda_permission" "main" {
  action        = "lambda:InvokeFunction"
  function_name = module.monitor.arn
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.main.arn
}
