# 1. Criação do API Gateway (HTTP API)
resource "aws_apigatewayv2_api" "main" {
  name          = "event-driven-api"
  protocol_type = "HTTP"
}

# 2. Stage (Ambiente, ex: default)
resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.main.id
  name        = "$default" # Deploy automático
  auto_deploy = true
}

# 3. Integração entre API Gateway e Lambda
resource "aws_apigatewayv2_integration" "lambda_ingest" {
  api_id           = aws_apigatewayv2_api.main.id
  integration_type = "AWS_PROXY"

  integration_uri    = aws_lambda_function.ingest.invoke_arn
  integration_method = "POST"
  payload_format_version = "2.0"
}

# 4. Rota (ex: POST /webhook)
resource "aws_apigatewayv2_route" "post_webhook" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "POST /webhook" # Define o verbo e o path
  target    = "integrations/${aws_apigatewayv2_integration.lambda_ingest.id}"
}

# 5. Permissão para o Gateway invocar a Lambda
resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ingest.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.main.execution_arn}/*/*"
}
