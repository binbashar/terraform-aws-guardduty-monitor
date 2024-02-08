[![Codacy Badge](https://api.codacy.com/project/badge/Grade/98a1b947bb6745899ed248ae91f62b34)](https://www.codacy.com/app/OpenDevSecOps/terraform-aws-guardduty-monitor?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=opendevsecops/terraform-aws-guardduty-monitor&amp;utm_campaign=Badge_Grade)
[![Follow on Twitter](https://img.shields.io/twitter/follow/opendevsecops.svg?logo=twitter)](https://twitter.com/opendevsecops)

# AWS GuardDuty Monitor Terraform Module

A terraform module to monitor GuardDuty with Slack and Email (soon).

## Getting Started

Getting started is easy. You will need GuardDuty provisioned via terraform or manually activated via the AWS console. Once GuardDuty is activated, simply import the module and configure as desired. Here is a complete example:

```terraform
resource "aws_guardduty_detector" "default" {
  enable = true
}

module "guardduty_monitor" {
  source = "opendevsecops/guardduty-monitor/aws"

  monitor_slack_notification_url = "${var.monitor_slack_notification_url}"
}
```

The module is automatically published to the Terraform Module Registry. More information about the available inputs, outputs, dependencies and instructions how to use the module can be found at the official page [here](https://registry.terraform.io/modules/opendevsecops/guardduty-monitor).

## Update notes (v1.2 -> v1.3)

The new version of this module stores the webhook URL more securely:

* If you provide the Webhook URL as a string, the module will create and then store it as a secret value in the AWS SSM Parameter Store (free service). 
* If you already have the Webhook URL in the AWS SSM Parameter Store service, you can provide the name, and the module will create the required permissions.
* If you already have the Webhook URL in the AWS Secret Manager service, you can provide the ARN and key, and the module will create the required permissions.
With this change, AWS Lambda will never expose the Webhook URL. 

This functionality relies on the AWS Parameters and Secrets Lambda Extension. This tool reduces latency and cost (by caching secrets and diminishing API calls). However, by default, it checks if the secret has changed every 10 minutes. You can adjust this behavior by modifying the settings.

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
| <a name="input_monitor_slack_notification_url"></a> [monitor\_slack\_notification\_url](#input\_monitor\_slack\_notification\_url) | URL for slack notifications | `any` | `null` | no |
| <a name="input_parameters_secrets_extension_http_port"></a> [parameters\_secrets\_extension\_http\_port](#input\_parameters\_secrets\_extension\_http\_port) | The port for the local HTTP server | `number` | `2773` | no |
| <a name="input_parameters_secrets_extension_log_level"></a> [parameters\_secrets\_extension\_log\_level](#input\_parameters\_secrets\_extension\_log\_level) | The level of detail reported in logs for the extension. | `any` | `null` | no |
| <a name="input_secrets_manager_ttl"></a> [secrets\_manager\_ttl](#input\_secrets\_manager\_ttl) | Maximum valid lifetime, in seconds, of a secret in the cache before it is invalidated. | `any` | `null` | no |
| <a name="input_slack_notification_url_secret_arn"></a> [slack\_notification\_url\_secret\_arn](#input\_slack\_notification\_url\_secret\_arn) | AWS Secret Manager ARN containing the URL for slack notifications | `any` | `null` | no |
| <a name="input_slack_notification_url_secret_key"></a> [slack\_notification\_url\_secret\_key](#input\_slack\_notification\_url\_secret\_key) | Key inside AWS Secret Manager Vault | `any` | `null` | no |
| <a name="input_slack_notification_url_ssm_encrypted"></a> [slack\_notification\_url\_ssm\_encrypted](#input\_slack\_notification\_url\_ssm\_encrypted) | Is SSM Parameter encrypted? | `string` | `"true"` | no |
| <a name="input_slack_notification_url_ssm_name"></a> [slack\_notification\_url\_ssm\_name](#input\_slack\_notification\_url\_ssm\_name) | SSM Parameter name containing the URL for slack notifications | `any` | `null` | no |
| <a name="input_ssm_parameter_store_ttl"></a> [ssm\_parameter\_store\_ttl](#input\_ssm\_parameter\_store\_ttl) | Maximum valid lifetime, in seconds, of a parameter in the cache before it is invalidated | `any` | `null` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->