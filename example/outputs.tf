output "rds_alarms_sns_topic_arn" {
  value = module.rds_alarms.sns_topic_arn
}

output "rds_alarms" {
  value = module.rds_alarms.rds_alarms_list
}
