data "aws_caller_identity" "default" {}

locals {
  create_sns_topic  = var.aws_sns_topic_arn == ""
  aws_sns_topic_arn = local.create_sns_topic ? aws_sns_topic.default.*.arn : [var.aws_sns_topic_arn]

  event_categories = {
    # A list of event categories for a SourceType that you want to subscribe to.
    # See http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_Events.html
    # or run aws rds describe-event-categories
    "db-cluster" : [
      "failover",
      "failure",
      "maintenance",
      "notification",
    ],
    "db-instance" : [
      "failover",
      "failure",
      "low storage",
      "maintenance",
      "notification",
      "recovery",
    ],
    "db-security-group" : [
      "configuration change",
      "failure",
    ],
    "db-parameter-group" : [
      "configuration change",
    ],
    # "db-snapshot" : [
    #   "creation",
    #   "restoration",
    #   "deletion",
    #   "notification",
    # ],
    # "db-cluster-snapshot" : [
    #   "backup",
    #   "notification",
    # ],
    "custom-engine-version" : [
      "failure",
    ],
  }
}

resource "aws_sns_topic" "default" {
  count = local.create_sns_topic ? 1 : 0

  name = "${var.name_prefix}-rds-alarm-topic"
}

resource "aws_db_event_subscription" "default" {
  name      = "${var.name_prefix}-db-event-sub"
  sns_topic = join("", local.aws_sns_topic_arn)

  source_type = var.source_type
  source_ids  = [var.db_instance_id]

  event_categories = local.event_categories[var.source_type]

  depends_on = [
    local.aws_sns_topic_arn
  ]
}

resource "aws_sns_topic_policy" "default" {
  count  = local.create_sns_topic ? 1 : 0
  arn    = join("", aws_sns_topic.default.*.arn)
  policy = join("", data.aws_iam_policy_document.sns_topic_policy.*.json)
}

data "aws_iam_policy_document" "sns_topic_policy" {
  count = local.create_sns_topic ? 1 : 0

  statement {
    sid = "AllowManageSNS"

    actions = [
      "SNS:Subscribe",
      "SNS:SetTopicAttributes",
      "SNS:RemovePermission",
      "SNS:Receive",
      "SNS:Publish",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:AddPermission",
    ]

    effect    = "Allow"
    resources = aws_sns_topic.default.*.arn

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"

      values = data.aws_caller_identity.default.*.account_id

    }
  }

  statement {
    sid       = "Allow CloudwatchEvents"
    actions   = ["sns:Publish"]
    resources = aws_sns_topic.default.*.arn

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }

  statement {
    sid       = "Allow RDS Event Notification"
    actions   = ["sns:Publish"]
    resources = aws_sns_topic.default.*.arn

    principals {
      type        = "Service"
      identifiers = ["rds.amazonaws.com"]
    }
  }
}
