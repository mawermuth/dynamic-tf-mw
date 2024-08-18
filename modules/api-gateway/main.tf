resource "aws_apigatewayv2_api" "ecs_gateway" {
  name          = "${var.api_name}-${var.infra_env}"
  protocol_type = var.api_protocol_type
}

resource "aws_apigatewayv2_stage" "ecs_gateway_stage" {
  api_id = aws_apigatewayv2_api.ecs_gateway.id

  name        = var.stage_name
  auto_deploy = var.stage_auto_deploy_bool

  access_log_settings {
    destination_arn = var.log_group

    format = jsonencode(
      {
        IntegrationLatency      = "$context.integrationLatency"
        errMsg                  = "$context.error.message"
        errType                 = "$context.error.responseType"
        httpMethod              = "$context.httpMethod"
        intError                = "$context.integration.error"
        intIntStatus            = "$context.integration.integrationStatus"
        intLat                  = "$context.integration.latency"
        intReqID                = "$context.integration.requestId"
        intStatus               = "$context.integration.status"
        integrationErrorMessage = "$context.integrationErrorMessage"
        integrationStatus       = "$context.integrationStatus"
        protocol                = "$context.protocol"
        requestId               = "$context.requestId"
        requestTime             = "$context.requestTime"
        resourcePath            = "$context.resourcePath"
        responseLength          = "$context.responseLength"
        routeKey                = "$context.routeKey"
        sourceIp                = "$context.identity.sourceIp"
        status                  = "$context.status"
      }
    )
  }
}

resource "aws_apigatewayv2_vpc_link" "ecs_vpc_link" {
  name               = "${var.vpc_link_name}-${var.infra_env}"
  security_group_ids = [var.public_security_group_api]
  subnet_ids         = var.subnets
}

resource "aws_apigatewayv2_integration" "ecs_vpc_lb_integration" {
  api_id = aws_apigatewayv2_api.ecs_gateway.id

  integration_uri    = var.integration_uri
  integration_type   = var.integration_type
  integration_method = var.integration_method
  connection_type    = var.connection_type
  connection_id      = aws_apigatewayv2_vpc_link.ecs_vpc_link.id
}

resource "aws_apigatewayv2_route" "api_gateway_routes" {
  api_id = aws_apigatewayv2_api.ecs_gateway.id

  route_key = var.route_key
  target    = "integrations/${aws_apigatewayv2_integration.ecs_vpc_lb_integration.id}"
}