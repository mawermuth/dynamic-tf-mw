environment_name         = "development"
environment_abbreviation = "dev"
namespace                = "dynamictf"
is_pr                    = false

ecr_list_data = [
  {
    ecr_name         = "dynamictf-node-test"
    image_mutability = "MUTABLE"
  }
]

ecs_data = {
  "dynamictf" = {
    name                   = "dynamictf-cluster"
    cloud_watch_group_name = "logs-tf"

    setting = {
      name  = "containerInsights"
      value = "enabled"
    }
    configuration = {
      logging        = "OVERRIDE"
      log_encryption = true
    }

    task_definition = [
      {
        family                   = "node"
        requires_compatibilities = ["FARGATE"]
        network_mode             = "awsvpc"
        cpu                      = 1024
        memory                   = 2048
        container_definitions = {
          name      = "node"
          essential = true
          portMappings = {
            name          = "node_be_portmap"
            containerPort = 3000
            hostPort      = 3000
            protocol      = "tcp"
            appProtocol   = "http"
          }
          logConfiguration = {
            logDriver = "awslogs"
            options = {
              awslogs-create-group  = "true"
              awslogs-group         = "be"
              awslogs-region        = "us-east-1"
              awslogs-stream-prefix = "node"
            }
          }
          environment = [
            {
              name  = "PORT"
              value = "3000"
            },
            {
              name  = "TZ"
              value = "Etc/GMT"
            },
            {
              name  = "ENVIRONMENT"
              value = "dynamictf"
            }
          ]
        }

        runtime_platform = {
          operating_system_family = "LINUX"
          cpu_architecture        = "X86_64"
        }
      }
    ]


    service = [
      {
        name          = "dynamictf-node-service"
        desired_count = 3

        force_new_deployment               = true
        deployment_maximum_percent         = 100
        deployment_minimum_healthy_percent = 50

        task_definition_name = "node"
        ordered_placement_strategy = {
          type  = "binpack"
          field = "cpu"
        }

        create_ecs_load_balancer = true
        create_service_connect   = false

        load_balancer = {
          container_name = "node"
          container_port = 3000
        }

        placement_constraints = {
          type       = "memberOf"
          expression = "attribute:ecs.availability-zone in [us-east-2a, us-east-2b]"
        }
      }
    ]

    capacity = {
      capacity_providers = ["FARGATE"]
      base               = 1
      weight             = 100
      capacity_provider  = "FARGATE"
    }

    load_balancer_data = {
      lb = {
        name                       = "nlb-ecs"
        internal                   = true
        load_balancer_type         = "network"
        enable_deletion_protection = false
      }

      lb_tg_data = {
        name        = "nlb-tg"
        port        = 3000
        protocol    = "TCP"
        target_type = "ip"
      }

      lb_tg_listener_data = {
        port     = "80"
        protocol = "TCP"
        default_action = {
          type = "forward"
        }
        certificate_arn = ""
      }
    }

    api_gateway_data = {
      api_name          = "ecs_api_http"
      api_protocol_type = "HTTP"

      stage_name             = "$default"
      stage_auto_deploy_bool = true

      vpc_link_name = "ecs_api_link_vpc"

      integration_type   = "HTTP_PROXY"
      integration_method = "ANY"
      connection_type    = "VPC_LINK"

      route_key = "$default"
    }
  }
}

load_balancer_data = {
  lb = {
    name                       = "alb"
    internal                   = false
    load_balancer_type         = "application"
    enable_deletion_protection = false
  }

  lb_tg_data = {
    name        = "alb-tg"
    port        = 80
    protocol    = "HTTP"
    target_type = "ip"
  }

  lb_tg_listener_data = {
    port     = "443"
    protocol = "HTTPS"
    default_action = {
      type = "forward"
    }

    certificate_arn = ""
  }
}

cloudfront_data = {
  fe_bucket_name         = "frontend"
  bucket_ownership       = "BucketOwnerPreferred"
  origin_name            = "frontend_cf_origin"
  origin_description     = "Origin access control for app frontend s3 bucket."
  origin_type            = "s3"
  origin_behavior        = "always"
  origin_protocol        = "sigv4"
  default_object         = "index.html"
  enabled                = true
  ipv6_enabled           = true
  certificate_arn        = ""
  alternate_domain_names = "dev.dynamictf.com"

  function = {
    name    = "fe-cloudfront-function"
    comment = "Cloudfront function for frontend routing."
    publish = true
  }

  default_cache_behavior = {
    allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods  = ["GET", "HEAD"]
    cookies_forward = "none"
    protocol_policy = "allow-all"
  }

  ordered_cache_behavior = {
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]
    cookies_forward = "none"
    protocol_policy = "allow-all"
  }
  restriction_type = "none"

  origin_request_policy = {
    comment         = "Policy for S3 origin with CORS"
    name            = "origin_test"
    cookie_behavior = "none"
    header_behavior = "whitelist"
    headers_items = [
      "access-control-request-headers",
      "access-control-request-method",
      "origin"
    ]
    query_string_behavior = "none"
  }

  cache_policy = {
    comment                       = "Policy with caching enabled. Supports Gzip and Brotli compression."
    name                          = "cache"
    enable_accept_encoding_brotli = true
    enable_accept_encoding_gzip   = true
    cookie_behavior               = "none"
    header_behavior               = "none"
    query_string_behavior         = "none"
  }
}

api_gateway_data = {
  api_name          = "ecs_lb_be_api_http"
  api_protocol_type = "HTTP"

  stage_name             = "$default"
  stage_auto_deploy_bool = true

  vpc_link_name = "ecs_api_lb_link_vpc"

  integration_type   = "HTTP_PROXY"
  integration_method = "ANY"
  connection_type    = "VPC_LINK"

  route_key = "$default"
}

rds_data = {
  identifier           = "database-tf"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0.33"
  instance_class       = "db.t3.micro"
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
}
