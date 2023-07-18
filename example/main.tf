locals {
  region = "us-east-2"
}

data "aws_caller_identity" "default" {}

provider "aws" {
  region  = local.region
}

resource "aws_db_instance" "default" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  identifier           = "test-db"
  db_name              = "mydb"
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = "default.mysql5.7"
  apply_immediately    = "true"
  skip_final_snapshot  = "true"
}

module "rds_alarms" {
  source            = "../"

  name_prefix       = "dev"
  db_instance_id    = aws_db_instance.default.id
  # aws_sns_topic_arn = "arn:aws:sns:${local.region}:${data.aws_caller_identity.default.account_id}:devops-notifications"
}
