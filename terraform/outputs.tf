output "api_endpoint" {
  value = aws_api_gateway_deployment.my_api_deployment.invoke_url
}
