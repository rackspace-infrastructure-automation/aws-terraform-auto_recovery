# AWS Terraform: Auto Recovery Module

Adds EC2 auto-recovery functionality to eligible instances.

A tag with name `RsAutoRecovery` and value of `True` is required to pick up instances that you want to apply auto-recovery to.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| failed_instance_checks_before_reboot | The number of failed instance status checks that should happen before triggering a reboot. | string | `5` | no |
| failed_instance_checks_before_ticket_raised | The number of failed instance status checks that should happen before raising a ticket. | string | `10` | no |
| failed_instance_checks_period | The amount, in seconds, to wait between instance status checks. | string | `60` | no |
| failed_system_checks_before_reboot | The number of failed system status checks that should happen before triggering a reboot. | string | `2` | no |
| failed_system_checks_before_ticket_raised | The number of failed system status checks that should happen before raising a ticket. | string | `5` | no |
| failed_system_checks_period | The amount, in seconds, to wait between system status checks. | string | `60` | no |
| instance_ids | A list of instances ID to filter by and set up auto recovery for. These must be tag with name RsAutoRecovery and value of exactly True. | list | - | yes |
