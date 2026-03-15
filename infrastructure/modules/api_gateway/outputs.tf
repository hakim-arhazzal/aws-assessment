output "api_endpoint" {
  description = "Base URL for the regional HTTP API."
  value       = aws_apigatewayv2_stage.default.invoke_url
}

output "greet_url" {
  description = "Regional greet endpoint."
  value       = "${aws_apigatewayv2_stage.default.invoke_url}/greet"
}

output "dispatch_url" {
  description = "Regional dispatch endpoint."
  value       = "${aws_apigatewayv2_stage.default.invoke_url}/dispatch"
}
