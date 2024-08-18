module "lb-dynamic" {
  source = "../lb"

  infra_env              = var.infra_env
  public_subnets         = var.public_subnets
  private_subnets        = var.private_subnets
  public_security_group  = var.public_security_group
  private_security_group = var.private_security_group
  vpc_id                 = var.vpc_id
  lb                     = var.lb
  lb_tg_data             = var.lb_tg_data
  lb_tg_listener_data    = var.lb_tg_listener_data
}

locals {
  cluster_name = var.name
  account_id   = data.aws_caller_identity.current.account_id
  region       = data.aws_region.current.name
}

resource "aws_service_discovery_http_namespace" "http-node-namespace" {
  name        = "node-${var.name}-${var.infra_env}"
  description = "Namespace for node platform."
}

resource "aws_cloudwatch_log_group" "cloudwatch_group" {
  name = "${var.cloud_watch_group_name}-${var.infra_env}"
}

resource "aws_cloudwatch_log_stream" "cloudwatch_log_stream" {
  name           = "log-stream-${var.infra_env}"
  log_group_name = aws_cloudwatch_log_group.cloudwatch_group.name
}

resource "aws_ecs_cluster" "ecs" {
  name = "${var.name}-${var.infra_env}"

  setting {
    name  = var.setting.name
    value = var.setting.value
  }

  configuration {
    execute_command_configuration {
      logging = var.configuration.logging

      log_configuration {
        cloud_watch_encryption_enabled = var.configuration.log_encryption
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.cloudwatch_group.name
      }
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "ecs_capacity" {
  cluster_name = aws_ecs_cluster.ecs.name

  capacity_providers = var.capacity.capacity_providers

  default_capacity_provider_strategy {
    base              = var.capacity.base
    weight            = var.capacity.weight
    capacity_provider = var.capacity.capacity_provider
  }
}

resource "aws_iam_role" "tf-iam-role" {
  name = "tf-iam-role-${var.infra_env}"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          "Service" : [
            "lambda.amazonaws.com",
            "ecs-tasks.amazonaws.com",
            "pullthroughcache.ecr.amazonaws.com",
            "replication.ecr.amazonaws.com",
            "ecr.amazonaws.com",
            "logger.cloudfront.amazonaws.com",
            "logs.amazonaws.com"
          ]
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "ecs_policy" {
  name = "ecs_policy"
  role = aws_iam_role.tf-iam-role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:PutImage",
          "ecr:*",
          "ssm:GetParameter",
          "ssm:GetParameters",
          "secretsmanager:GetSecretValue",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:ListTagsForResource",
          "logs:ListTagsLogGroup",
          "logs:GetLogDelivery",
          "logs:GetLogEvents",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:DeleteLogGroup",
          "logs:DeleteLogStream",
          "logs:PutLogEvents",
          "logs:TagLogGroup",
          "logs:*"
        ],
        "Resource" : "*"
      }
    ]
  })
}

data "aws_iam_role" "tf-execution-iam-role" {
  name = aws_iam_role.tf-iam-role.name
}

resource "aws_ecs_task_definition" "dynamic-task" {
  for_each = {
    for task_definition in var.task_definition : "${task_definition.family}-${var.infra_env}" => task_definition
  }
  family                   = "${each.value.family}-${var.infra_env}"
  requires_compatibilities = each.value.requires_compatibilities
  network_mode             = each.value.network_mode
  cpu                      = each.value.cpu
  memory                   = each.value.memory
  task_role_arn            = aws_iam_role.tf-iam-role.arn
  execution_role_arn       = data.aws_iam_role.tf-execution-iam-role.arn

  container_definitions = jsonencode([
    {
      name      = "${each.value.container_definitions.name}-${var.infra_env}",
      image     = "${local.account_id}.dkr.ecr.${local.region}.amazonaws.com/${each.value.family}-${var.infra_env}",
      cpu       = "${each.value.cpu}",
      memory    = "${each.value.memory}",
      essential = "${each.value.container_definitions.essential}",
      portMappings = [
        {
          name          = "${each.value.container_definitions.portMappings.name}",
          containerPort = "${each.value.container_definitions.portMappings.containerPort}",
          hostPort      = "${each.value.container_definitions.portMappings.hostPort}",
          protocol      = "${each.value.container_definitions.portMappings.protocol}",
          appProtocol   = "${each.value.container_definitions.portMappings.appProtocol}",
        }
      ],
      logConfiguration = {
        logDriver = "${each.value.container_definitions.logConfiguration.logDriver}"
        options = {
          awslogs-create-group  = "${each.value.container_definitions.logConfiguration.options.awslogs-create-group}",
          awslogs-group         = "${each.value.container_definitions.logConfiguration.options.awslogs-group}",
          awslogs-region        = "${each.value.container_definitions.logConfiguration.options.awslogs-region}",
          awslogs-stream-prefix = "${each.value.container_definitions.logConfiguration.options.awslogs-stream-prefix}-${var.infra_env}"
        }
      },
      environment = "${each.value.container_definitions.environment}"
      # secrets = [
      #   {
      #     name      = "DATABASE_USERNAME",
      #     valueFrom = "${data.aws_secretsmanager_secret.rds.arn}:username::"
      #   },
      #   {
      #     name      = "DATABASE_PASSWORD",
      #     valueFrom = "${data.aws_secretsmanager_secret.rds.arn}:password::"
      #   },
      #   {
      #     name      = "DATABASE_ENGINE",
      #     valueFrom = "${data.aws_secretsmanager_secret.rds.arn}:engine::"
      #   },
      #   {
      #     name      = "DATABASE_HOST",
      #     valueFrom = "${data.aws_secretsmanager_secret.rds.arn}:host::"
      #   },
      #   {
      #     name      = "DATABASE_PORT",
      #     valueFrom = "${data.aws_secretsmanager_secret.rds.arn}:port::"
      #   }
      # ]
    }
  ])

  runtime_platform {
    operating_system_family = each.value.runtime_platform.operating_system_family
    cpu_architecture        = each.value.runtime_platform.cpu_architecture
  }

  tags = {
  }
}

module "ecs-service" {
  source = "../ecs-service"

  for_each = {
    for service in var.service : "${service.name}-${var.infra_env}" => service
  }

  name                     = each.value.name
  infra_env                = var.infra_env
  cluster                  = aws_ecs_cluster.ecs.id
  task_definition          = aws_ecs_task_definition.dynamic-task["${each.value.task_definition_name}-${var.infra_env}"].arn
  subnets                  = var.public_subnets
  security_groups          = [var.private_security_group]
  target_group_arn         = module.lb-dynamic.ip_tg_arn
  container_name           = each.value.load_balancer.container_name
  container_port           = each.value.load_balancer.container_port
  desired_count            = each.value.desired_count
  create_ecs_load_balancer = each.value.create_ecs_load_balancer
  create_service_connect   = each.value.create_service_connect
  namespace                = aws_service_discovery_http_namespace.http-node-namespace.arn
  cloudwatch_group         = aws_cloudwatch_log_group.cloudwatch_group.name
}