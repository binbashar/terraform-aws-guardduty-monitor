[![Codacy Badge](https://api.codacy.com/project/badge/Grade/98a1b947bb6745899ed248ae91f62b34)](https://www.codacy.com/app/OpenDevSecOps/terraform-aws-guardduty-monitor?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=opendevsecops/terraform-aws-guardduty-monitor&amp;utm_campaign=Badge_Grade)
[![Follow on Twitter](https://img.shields.io/twitter/follow/opendevsecops.svg?logo=twitter)](https://twitter.com/opendevsecops)

# AWS GuardDuty Monitor Terraform Module

A terraform module to monitor GuardDuty with Slack and Email (soon).

## Getting Started

Getting started is easy. You will need GuardDuty provisioned via terraform or manually activated via the AWS console. Once GuardDuty is activated, simply import the module and configure as desired. Here is a complete example:

```terraform

locals {
  slack_notification_url = "https://hooks.slack.com/services/ABCDEFGHIJK/012345678910/A1B2C3D4E5F6G7H8I9J0"
  A1B2C3D4E5F6G7H8I9J0
}

resource "aws_secretsmanager_secret" "slack_notifications" {
  name = "slack_notifications"
}

resource "aws_secretsmanager_secret_version" "slack_notifications" {
  secret_id     = aws_secretsmanager_secret.slack_notifications.id
  secret_string = local.slack_notification_url
}

resource "aws_guardduty_detector" "default" {
  enable = true
}

module "guardduty_monitor" {
  source = "opendevsecops/guardduty-monitor/aws"

  monitor_slack_notification_url = "${local.aws_secretsmanager_secret_version}"
}
```

The module is automatically published to the Terraform Module Registry. More information about the available inputs, outputs, dependencies and instructions how to use the module can be found at the official page [here](https://registry.terraform.io/modules/opendevsecops/guardduty-monitor).

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_monitor"></a> [monitor](#module\_monitor) | ./modules/monitor | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_lambda_permission.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_event_rule_name"></a> [event\_rule\_name](#input\_event\_rule\_name) | The event rule's name | `string` | `"opendevsecops_guardduty_monitor"` | no |
| <a name="input_monitor_name"></a> [monitor\_name](#input\_monitor\_name) | A unique name for your Lambda Function | `string` | `"opendevsecops_guardduty_monitor"` | no |
| <a name="input_monitor_role_name"></a> [monitor\_role\_name](#input\_monitor\_role\_name) | A unique name for your Lambda Function Role | `string` | `"opendevsecops_guardduty_monitor_role"` | no |
| <a name="input_monitor_slack_notification_url"></a> [monitor\_slack\_notification\_url](#input\_monitor\_slack\_notification\_url) | AWS Secrets Manager ARN where stored URL for slack notifications | `any` | `null` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->