output "api_url" {
  value = "https://${aws_apigatewayv2_api.test.id}.execute-api.${data.aws_region.current.name}.amazonaws.com/${var.stage_name}"
}

output "api_id" {
  value = aws_apigatewayv2_api.this.id
}