variable "db_instance_id" {
  description = "The instance ID of the RDS database instance that you want to monitor."
  type        = string
}

variable "name_prefix" {
  description = "Name prefix for SNS topic and event subscription"
  type        = string
  default     = ""
}

variable "burst_balance_threshold" {
  description = "The minimum percent of General Purpose SSD (gp2) burst-bucket I/O credits available."
  type        = number
  default     = 20
}

variable "cpu_utilization_threshold" {
  description = "The maximum percentage of CPU utilization."
  type        = number
  default     = 80
}

variable "cpu_credit_balance_threshold" {
  description = "The minimum number of CPU credits (t2 instances only) available."
  type        = number
  default     = 20
}

variable "disk_queue_depth_threshold" {
  description = "The maximum number of outstanding IOs (read/write requests) waiting to access the disk."
  type        = number
  default     = 64
}

variable "freeable_memory_threshold" {
  description = "The minimum amount of available random access memory in Byte."
  type        = number
  default     = 64000000

  # 64 Megabyte in Byte
}

variable "free_storage_space_threshold" {
  description = "The minimum amount of available storage space in Byte."
  type        = number
  default     = 5000000000

  # 5 Gigabyte in Byte
}

variable "swap_usage_threshold" {
  description = "The maximum amount of swap space used on the DB instance in Byte."
  type        = number
  default     = 256000000

  # 256 Megabyte in Byte
}

variable "metric_alarm_period" {
  description = "Duration in seconds to evaluate for the alarm"
  type        = number
  default     = 300

  # 5 minutes
}


variable "evaluation_periods" {
  description = "Number of periods to evaluate for the alarm"
  type        = number
  default     = 2
}



variable "aws_sns_topic_arn" {
  description = "ARN of an already existing SNS topic."
  type        = string
  default     = ""
}

variable "source_type" {
  type        = string
  default     = "db-instance"
  description = "The type of source that will be generating the events"
  validation {
    condition     = contains(["db-instance", "db-security-group", "db-parameter-group", "db-snapshot", "db-cluster", "db-cluster-snapshot", "custom-engine-version"], var.source_type)
    error_message = "Valid options are \"db-instance\", \"db-security-group\", \"db-parameter-group\", \"db-snapshot\", \"db-cluster\" or \"db-cluster-snapshot\", \"custom-engine-version\"."
  }
}
