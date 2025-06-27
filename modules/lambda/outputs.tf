output "lambda_arn" {
  value = aws_lambda_function.test.arn
}

output "lambda_name" {
  value = aws_lambda_function.test.function_name
}

output "lambda_alias_arn" {
  value = aws_lambda_alias.test.arn
}