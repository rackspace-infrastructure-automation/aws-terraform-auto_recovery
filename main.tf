locals {
  instance_ids = "${compact(var.instance_ids)}"
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_instances" "auto_recovery_instances" {
  filter {
    name = "instance-type"

    values = [
      "c3.*",
      "c4.*",
      "c5.*",
      "m3.*",
      "m4.*",
      "m5.*",
      "r3.*",
      "r4.*",
      "r5.*",
      "t2.*",
      "t3.*",
      "x1.*",
      "x1e.*",
    ]
  }

  filter {
    name   = "instance-id"
    values = ["${local.instance_ids}"]
  }

  instance_tags {
    RsAutoRecovery = "True"
  }
}

data "aws_instance" "auto_recovery_instance" {
  count = "${length(data.aws_instances.auto_recovery_instances.ids)}"

  instance_id = "${data.aws_instances.auto_recovery_instances.ids[count.index]}"
}

resource "aws_cloudwatch_metric_alarm" "status_check_failed_instance_alarm_reboot" {
  count = "${length(data.aws_instance.auto_recovery_instance.*.id)}"

  alarm_actions       = ["arn:aws:swf:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:action/actions/AWS_EC2.InstanceId/Reboot/1.0"]
  alarm_description   = "Status checks have failed, rebooting system"
  alarm_name          = "${data.aws_instance.auto_recovery_instance.*.tags.Name[count.index]} - StatusCheckFailedInstanceAlarmReboot"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "${var.failed_instance_checks_before_reboot}"
  metric_name         = "StatusCheckFailed_Instance"
  namespace           = "AWS/EC2"
  period              = "${var.failed_instance_checks_period}"
  statistic           = "Minimum"
  threshold           = "0"
  unit                = "Count"

  dimensions {
    InstanceId = "${data.aws_instance.auto_recovery_instance.*.id[count.index]}"
  }
}

resource "aws_cloudwatch_metric_alarm" "status_check_failed_instance_alarm_ticket" {
  count = "${length(data.aws_instance.auto_recovery_instance.*.id)}"

  alarm_actions       = ["arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:rackspace-support-emergency"]
  alarm_description   = "Status checks have failed, generating ticket."
  alarm_name          = "${data.aws_instance.auto_recovery_instance.*.tags.Name[count.index]} - StatusCheckFailedInstanceAlarmTicket"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "${var.failed_instance_checks_before_ticket_raised}"
  metric_name         = "StatusCheckFailed_Instance"
  namespace           = "AWS/EC2"
  ok_actions          = ["arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:rackspace-support-emergency"]
  period              = "${var.failed_instance_checks_period}"
  statistic           = "Minimum"
  threshold           = "0"
  unit                = "Count"

  dimensions {
    InstanceId = "${data.aws_instance.auto_recovery_instance.*.id[count.index]}"
  }
}

resource "aws_cloudwatch_metric_alarm" "status_check_failed_system_alarm_recover" {
  count = "${length(data.aws_instance.auto_recovery_instance.*.id)}"

  alarm_actions       = ["arn:aws:automate:${data.aws_region.current.name}:ec2:recover"]
  alarm_description   = "Status checks have failed for system, recovering instance"
  alarm_name          = "${data.aws_instance.auto_recovery_instance.*.tags.Name[count.index]} - StatusCheckFailedSystemAlarmRecover"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "${var.failed_system_checks_before_reboot}"
  metric_name         = "StatusCheckFailed_System"
  namespace           = "AWS/EC2"
  period              = "${var.failed_system_checks_period}"
  statistic           = "Minimum"
  threshold           = "0"
  unit                = "Count"

  dimensions {
    InstanceId = "${data.aws_instance.auto_recovery_instance.*.id[count.index]}"
  }
}

resource "aws_cloudwatch_metric_alarm" "status_check_failed_system_alarm_ticket" {
  count = "${length(data.aws_instance.auto_recovery_instance.*.id)}"

  alarm_actions       = ["arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:rackspace-support-emergency"]
  alarm_description   = "Status checks have failed for system, recovering instance"
  alarm_name          = "${data.aws_instance.auto_recovery_instance.*.tags.Name[count.index]} - StatusCheckFailedSystemAlarmTicket"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "${var.failed_system_checks_before_ticket_raised}"
  metric_name         = "StatusCheckFailed_System"
  namespace           = "AWS/EC2"
  ok_actions          = ["arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:rackspace-support-emergency"]
  period              = "${var.failed_system_checks_period}"
  statistic           = "Minimum"
  threshold           = "0"
  unit                = "Count"

  dimensions {
    InstanceId = "${data.aws_instance.auto_recovery_instance.*.id[count.index]}"
  }
}
