resource "aws_ecs_service" "be_service" {
  name            = "${var.name}-${var.infra_env}"
  cluster         = var.cluster
  task_definition = var.task_definition
  desired_count   = var.desired_count

  force_new_deployment               = var.force_new_deployment
  deployment_maximum_percent         = var.deployment_maximum_percent
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent

  network_configuration {
    subnets          = var.subnets
    security_groups  = var.security_groups
    assign_public_ip = true
  }

  launch_type = "FARGATE"

  service_connect_configuration {
    enabled   = true
    namespace = var.namespace
  }

  dynamic "load_balancer" {
    for_each = var.create_ecs_load_balancer == true ? ["filled"] : []
    content {
      target_group_arn = var.target_group_arn
      container_name   = "${var.container_name}-${var.infra_env}"
      container_port   = var.container_port
    }
  }
}