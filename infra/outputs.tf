output "api_endpoint" {
  description = "URL base do API Gateway"
  value       = aws_apigatewayv2_api.main.api_endpoint
}

output "webhook_url" {
    description = "URL completa para teste"
    value = "${aws_apigatewayv2_api.main.api_endpoint}/webhook"
}
