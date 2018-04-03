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
      "t2.*",
      "x1.*",
    ]
  }

  filter {
    name   = "instance-id"
    values = ["${var.instance_ids}"]
  }

  instance_tags {
    RsAutoRecovery = "True"
  }
}

resource "aws_cloudwatch_metric_alarm" "status_check_failed_instance_alarm_reboot" {
  alarm_name          = "${var.name_tag} - StatusCheckFailedInstanceAlarmReboot"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "5"
  metric_name         = "StatusCheckFailed_Instance"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Minimum"
  threshold           = "0"
  unit                = "Count"
  alarm_description   = "Status checks have failed, rebooting system"

  dimensions {
    InstanceId = "${var.instance}"
  }

  alarm_actions = ["arn:aws:swf:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:action/actions/AWS_EC2.InstanceId/Reboot/1.0"]
}

resource "aws_cloudwatch_metric_alarm" "status_check_failed_system_alarm_recover" {
  alarm_name          = "${var.name_tag} - StatusCheckFailedSystemAlarmRecover"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "StatusCheckFailed_System"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Minimum"
  threshold           = "0"
  unit                = "Count"
  alarm_description   = "Status checks have failed for system, recovering instance"

  dimensions {
    InstanceId = "${var.instance}"
  }

  alarm_actions = ["arn:aws:automate:${data.aws_region.current.name}:ec2:recover"]
}
