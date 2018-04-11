variable "instance_ids" {
  description = "A list of instances ID to filter by and set up auto recovery for. These must be tag with name RsAutoRecovery and value of exactly True."
  type        = "list"
}

variable "failed_instance_checks_before_reboot" {
  default     = "5"
  description = "The number of failed instance status checks that should happen before triggering a reboot."
  type        = "string"
}

variable "failed_instance_checks_before_ticket_raised" {
  default     = "10"
  description = "The number of failed instance status checks that should happen before raising a ticket."
  type        = "string"
}

variable "failed_instance_checks_period" {
  default     = "60"
  description = "The amount, in seconds, to wait between instance status checks."
  type        = "string"
}

variable "failed_system_checks_before_reboot" {
  default     = "2"
  description = "The number of failed system status checks that should happen before triggering a reboot."
  type        = "string"
}

variable "failed_system_checks_before_ticket_raised" {
  default     = "5"
  description = "The number of failed system status checks that should happen before raising a ticket."
  type        = "string"
}

variable "failed_system_checks_period" {
  default     = "60"
  description = "The amount, in seconds, to wait between system status checks."
  type        = "string"
}
