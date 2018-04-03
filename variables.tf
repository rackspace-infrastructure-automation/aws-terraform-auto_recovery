variable "instance_ids" {
  description = "A list of instances ID to filter by and set up auto recovery for. These must be tag with name RsAutoRecovery and value of exactly True."
  type        = "list"
}
