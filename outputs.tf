output "sns_topic_arn" {
  description = "The ARN of the SNS topic"
  value       = join("", local.aws_sns_topic_arn)
}

output "rds_alarms_list" {
  description = "The list of all alarms"
  value = [
    [aws_cloudwatch_metric_alarm.burst_balance_too_low.arn],
    [aws_cloudwatch_metric_alarm.cpu_utilization_too_high.arn],
    [aws_cloudwatch_metric_alarm.cpu_credit_balance_too_low.arn],
    [aws_cloudwatch_metric_alarm.disk_queue_depth_too_high.arn],
    [aws_cloudwatch_metric_alarm.freeable_memory_too_low.arn],
    [aws_cloudwatch_metric_alarm.free_storage_space_too_low.arn],
    [aws_cloudwatch_metric_alarm.swap_usage_too_high.arn]
  ]
}
