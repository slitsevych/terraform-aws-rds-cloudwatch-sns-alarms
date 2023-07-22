locals {
  thresholds = {
    BurstBalanceThreshold     = min(max(var.burst_balance_threshold, 0), 100)
    CPUUtilizationThreshold   = min(max(var.cpu_utilization_threshold, 0), 100)
    CPUCreditBalanceThreshold = max(var.cpu_credit_balance_threshold, 0)
    DiskQueueDepthThreshold   = max(var.disk_queue_depth_threshold, 0)
    FreeableMemoryThreshold   = max(var.freeable_memory_threshold, 0)
    FreeStorageSpaceThreshold = max(var.free_storage_space_threshold, 0)
    SwapUsageThreshold        = max(var.swap_usage_threshold, 0)
  }
}

resource "aws_cloudwatch_metric_alarm" "burst_balance_too_low" {
  alarm_name          = "${var.name_prefix}-Burst_Balance_Too_Low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = "BurstBalance"
  namespace           = "AWS/RDS"
  period              = var.metric_alarm_period
  statistic           = "Average"
  threshold           = local.thresholds["BurstBalanceThreshold"]
  alarm_description   = "Average ${var.name_prefix} database storage burst balance over last 5 minutes is too low: expect a significant performance drop soon"
  alarm_actions       = var.use_sns_topic_for_alarms == true ? local.aws_sns_topic_arn : []
  ok_actions          = var.use_sns_topic_for_alarms == true ? local.aws_sns_topic_arn : []

  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_utilization_too_high" {
  alarm_name          = "${var.name_prefix}-CPU_Utilization_Too_High"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = var.metric_alarm_period
  statistic           = "Average"
  threshold           = local.thresholds["CPUUtilizationThreshold"]
  alarm_description   = "Average ${var.name_prefix} database CPU utilization over last 5 minutes is too high"
  alarm_actions       = var.use_sns_topic_for_alarms == true ? local.aws_sns_topic_arn : []
  ok_actions          = var.use_sns_topic_for_alarms == true ? local.aws_sns_topic_arn : []

  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_credit_balance_too_low" {
  alarm_name          = "${var.name_prefix}-CPU_Credit_Balance_Too_Low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = "CPUCreditBalance"
  namespace           = "AWS/RDS"
  period              = var.metric_alarm_period
  statistic           = "Average"
  threshold           = local.thresholds["CPUCreditBalanceThreshold"]
  alarm_description   = "Average ${var.name_prefix} database CPU credit balance over last 5 minutes is too low: expect a significant performance drop soon"
  alarm_actions       = var.use_sns_topic_for_alarms == true ? local.aws_sns_topic_arn : []
  ok_actions          = var.use_sns_topic_for_alarms == true ? local.aws_sns_topic_arn : []

  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "disk_queue_depth_too_high" {
  alarm_name          = "${var.name_prefix}-Disk_Queue_Depth_Too_High"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = "DiskQueueDepth"
  namespace           = "AWS/RDS"
  period              = var.metric_alarm_period
  statistic           = "Average"
  threshold           = local.thresholds["DiskQueueDepthThreshold"]
  alarm_description   = "Average ${var.name_prefix} database disk queue depth over last 5 minutes is too high: performance may suffer"
  alarm_actions       = var.use_sns_topic_for_alarms == true ? local.aws_sns_topic_arn : []
  ok_actions          = var.use_sns_topic_for_alarms == true ? local.aws_sns_topic_arn : []

  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "freeable_memory_too_low" {
  alarm_name          = "${var.name_prefix}-Freeable_Memory_Too_Low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = var.metric_alarm_period
  statistic           = "Average"
  threshold           = local.thresholds["FreeableMemoryThreshold"]
  alarm_description   = "Average ${var.name_prefix} database freeable memory over last 5 minutes is too low: performance may suffer"
  alarm_actions       = var.use_sns_topic_for_alarms == true ? local.aws_sns_topic_arn : []
  ok_actions          = var.use_sns_topic_for_alarms == true ? local.aws_sns_topic_arn : []

  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "free_storage_space_too_low" {
  alarm_name          = "${var.name_prefix}-Free_Storage_Space_Low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = var.metric_alarm_period
  statistic           = "Average"
  threshold           = local.thresholds["FreeStorageSpaceThreshold"]
  alarm_description   = "Average ${var.name_prefix} database free storage space over last 5 minutes is too low"
  alarm_actions       = var.use_sns_topic_for_alarms == true ? local.aws_sns_topic_arn : []
  ok_actions          = var.use_sns_topic_for_alarms == true ? local.aws_sns_topic_arn : []

  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "swap_usage_too_high" {
  alarm_name          = "${var.name_prefix}-Swap_Usage_Too_High"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = "SwapUsage"
  namespace           = "AWS/RDS"
  period              = var.metric_alarm_period
  statistic           = "Average"
  threshold           = local.thresholds["SwapUsageThreshold"]
  alarm_description   = "Average ${var.name_prefix} database swap usage over last 5 minutes is too high: performance may suffer"
  alarm_actions       = var.use_sns_topic_for_alarms == true ? local.aws_sns_topic_arn : []
  ok_actions          = var.use_sns_topic_for_alarms == true ? local.aws_sns_topic_arn : []

  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}
