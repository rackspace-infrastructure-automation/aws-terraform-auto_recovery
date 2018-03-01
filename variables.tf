variable "instance" {
  type        = "string"
  description = "The EC2 Instance ID to attach the auto recovery alarms to"
}

variable "name_tag" {
  type        = "string"
  description = "The EC2 Instance Name Tag"
}
