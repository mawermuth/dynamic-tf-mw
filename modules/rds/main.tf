# data "aws_db_snapshot" "latest_stg_db_snapshot" {
#   db_instance_identifier = "nprd-db-stg"

#   most_recent = true
# }

resource "aws_secretsmanager_secret" "my_rds_instance_secret" {
  name        = "rds-tf-secret-${var.infra_env}"
  description = "This is my RDS instance secret"

  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "my_rds_instance_secret_version" {
  secret_id = aws_secretsmanager_secret.my_rds_instance_secret.id
  secret_string = jsonencode(
    {
      "username" : "rdsuser${var.infra_env}",
      "password" : "${random_password.password.result}",
      "engine" : "${aws_db_instance.rds_instance.engine}",
      "host" : "rds://${aws_db_instance.rds_instance.address}:${aws_db_instance.rds_instance.port}/dynamic-tf",
      "host_short" : "${aws_db_instance.rds_instance.address}",
      "port" : "${aws_db_instance.rds_instance.port}"
    }
  )
}

locals {
  secret_values = jsondecode(aws_secretsmanager_secret_version.my_rds_instance_secret_version.secret_string)
}

resource "random_password" "password" {
  length           = 16
  special          = false
  override_special = "_%"
}

resource "aws_db_subnet_group" "my_db_subnet_group" {
  name       = "rds-subnet-group-${var.infra_env}"
  subnet_ids = var.public_subnets

  tags = {
    Name = "rds-subnet-group-${var.infra_env}"
  }
}

resource "aws_security_group" "rds_security_group" {
  name_prefix = "rds_security_group"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Outbund"
  }

  ingress {
    from_port   = 1150
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/17"]
    description = "MySQL inbound from 10.0.0.0/17"
  }

  tags = {
    Name = "rds_security_group_${var.infra_env}"
  }
}

resource "aws_db_instance" "rds_instance" {
  identifier           = "${var.identifier}-${var.infra_env}"
  allocated_storage    = var.allocated_storage
  storage_type         = var.storage_type
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  username             = "rdsuser${var.infra_env}"
  password             = random_password.password.result
  parameter_group_name = var.parameter_group_name
  skip_final_snapshot  = var.skip_final_snapshot

  vpc_security_group_ids = [aws_security_group.rds_security_group.id]

  db_subnet_group_name = aws_db_subnet_group.my_db_subnet_group.name

  tags = {
  }
}

resource "null_resource" "db_setup" {
}