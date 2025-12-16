# API Gateway HTTP Protocol
resource "aws_apigatewayv2_api" "main" {
  name          = "go-events"
  protocol_type = "HTTP"
  description   = "Serverless API Gateway for GO Events API"
}

# Create the cloudwatch log group
resource "aws_cloudwatch_log_group" "api_gw" {
  name              = "/aws/api-gateway/go-events"
  retention_in_days = 1
}

# Deployment Stage
resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.main.id
  name        = "$default"
  auto_deploy = true

  #Enable logging
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw.arn
    format          = "$context.requestId $context.identity.sourceIp $context.requestTime $context.httpMethod $context.routeKey $context.status $context.protocol $context.responseLength $context.integrationErrorMessage"
  }
}
