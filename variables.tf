variable "monitor_name" {
  description = "A unique name for your Lambda Function"
  default     = "opendevsecops_guardduty_monitor"
}

variable "monitor_role_name" {
  description = "A unique name for your Lambda Function Role"
  default     = "opendevsecops_guardduty_monitor_role"
}

variable "monitor_slack_notification_url" {
  description = "URL for slack notifications"
  default     = null
}

variable "event_rule_name" {
  description = "The event rule's name"
  default     = "opendevsecops_guardduty_monitor"
}

variable "slack_notification_url_secret_arn" {
  description = "AWS Secret Manager ARN containing the URL for slack notifications"
  default     = null
}

variable "slack_notification_url_secret_key" {
  description = "Key inside AWS Secret Manager Vault"
  default     = null
}

variable "slack_notification_url_ssm_name" {
  description = "SSM Parameter name containing the URL for slack notifications"
  default     = null
  validation {
    condition     = var.slack_notification_url_ssm_name == null || can(regex("^/", var.slack_notification_url_ssm_name))
    error_message = "The variable must start with '/'"
  }
}

variable "slack_notification_url_ssm_encrypted" {
  description = "Is SSM Parameter encrypted?"
  type        = string
  default     = "true"

  validation {
    condition     = can(regex("^(true|false)$", var.slack_notification_url_ssm_encrypted))
    error_message = "The variable must be either 'true' or 'false' and must be a string"
  }
}

variable "ssm_parameter_store_ttl" {
  description = "Maximum valid lifetime, in seconds, of a parameter in the cache before it is invalidated"
  default     = null
}

variable "secrets_manager_ttl" {
  description = "Maximum valid lifetime, in seconds, of a secret in the cache before it is invalidated."
  default     = null
}

variable "parameters_secrets_extension_log_level" {
  description = "The level of detail reported in logs for the extension."
  default     = null
}

variable "parameters_secrets_extension_http_port" {
  description = "The port for the local HTTP server"
  default     = 2773
}