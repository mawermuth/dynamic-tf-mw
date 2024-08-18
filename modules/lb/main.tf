module "s3-bucket" {
  source = "../s3"

  bucket_name       = "logs-${var.lb.name}-${var.infra_env}"
  bucket_versioning = "Disabled"
  bucket_ownership  = var.lb_logs_bucket_ownership
  bucket_policy     = data.aws_iam_policy_document.allow_lb.json
  bucket_website    = false
  bucket_cors       = false
}

# S3 Bucket Policy Document
data "aws_iam_policy_document" "allow_lb" {
  statement {
    effect = "Allow"
    resources = [
      "arn:aws:s3:::${module.s3-bucket.bucket}/lb-access-logs/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
    ]
    actions = ["s3:PutObject"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_elb_service_account.main.id}:root"]
    }
  }

  statement {
    effect = "Allow"
    resources = [
      "arn:aws:s3:::${module.s3-bucket.bucket}/lb-access-logs/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
    ]
    actions = ["s3:PutObject"]
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }

  statement {
    effect = "Allow"
    resources = [
      "arn:aws:s3:::${module.s3-bucket.bucket}",
    ]
    actions = ["s3:GetBucketAcl"]
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
  }
}

resource "aws_lb" "lb" {
  name               = "${var.lb.name}-${var.infra_env}"
  internal           = var.lb.internal
  load_balancer_type = var.lb.load_balancer_type
  security_groups    = [var.public_security_group]
  subnets            = var.public_subnets

  access_logs {
    bucket  = "logs-${var.lb.name}-${var.infra_env}"
    prefix  = "lb-access-logs"
    enabled = true
  }

  enable_deletion_protection = var.lb.enable_deletion_protection
}

resource "aws_lb_target_group" "ip_tg" {
  depends_on = [aws_lb.lb]

  name            = "${var.lb_tg_data.name}-${var.infra_env}"
  port            = var.lb_tg_data.port
  protocol        = var.lb_tg_data.protocol
  target_type     = var.lb_tg_data.target_type
  ip_address_type = "ipv4"
  vpc_id          = var.vpc_id

  deregistration_delay = var.deregistration_delay

  health_check {
    path                = var.health_check_path
    port                = "traffic-port"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 2
    interval            = 60
    matcher             = "200,403,404"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# locals {
#   nlb_eni_ip_list_integration = data.aws_network_interface.lb_names.*.private_ip
# }

# resource "aws_lb_target_group_attachment" "ip_tg_attachment" {
#   count = var.lb.load_balancer_type == "application" ? length(local.nlb_eni_ip_list_integration) : 0

#   depends_on       = [aws_lb_target_group.ip_tg]
#   target_group_arn = aws_lb_target_group.ip_tg.arn
#   target_id        = local.nlb_eni_ip_list_integration[count.index]
#   port             = var.lb_tg_data.port
# }

resource "aws_lb_listener" "tg_listener" {
  load_balancer_arn = aws_lb.lb.arn
  port              = var.lb_tg_listener_data.port
  protocol          = var.lb_tg_listener_data.protocol
  depends_on        = [aws_lb_target_group.ip_tg]
  certificate_arn   = var.lb.load_balancer_type == "application" ? var.lb_tg_listener_data.certificate_arn : ""

  default_action {
    target_group_arn = aws_lb_target_group.ip_tg.arn
    type             = var.lb_tg_listener_data.default_action.type
  }
}