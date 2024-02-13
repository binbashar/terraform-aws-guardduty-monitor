variable "monitor_name" {
  description = "A unique name for your Lambda Function"
  default     = "opendevsecops_guardduty_monitor"
}

variable "monitor_role_name" {
  description = "A unique name for your Lambda Function Role"
  default     = "opendevsecops_guardduty_monitor_role"
}

variable "monitor_slack_notification_url" {
  description = "AWS Secrets Manager ARN where stored URL for slack notifications"
}

variable "event_rule_name" {
  description = "The event rule's name"
  default     = "opendevsecops_guardduty_monitor"
}