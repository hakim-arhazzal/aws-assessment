output "invoke_arn" {
  description = "Lambda invoke ARN for API integration."
  value       = aws_lambda_function.this.invoke_arn
}

output "function_name" {
  description = "Lambda function name for invoke permissions."
  value       = aws_lambda_function.this.function_name
}

