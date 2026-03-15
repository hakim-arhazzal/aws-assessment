output "region" {
  description = "Region where the stack was deployed."
  value       = var.aws_region
}

output "api_endpoint" {
  description = "Base URL for the regional HTTP API."
  value       = module.api_gateway.api_endpoint
}

output "greet_url" {
  description = "Regional greet endpoint."
  value       = module.api_gateway.greet_url
}

output "dispatch_url" {
  description = "Regional dispatch endpoint."
  value       = module.api_gateway.dispatch_url
}

output "dynamodb_table_name" {
  description = "Regional DynamoDB table name."
  value       = aws_dynamodb_table.greeting_logs.name
}

output "ecs_cluster_arn" {
  description = "Regional ECS cluster ARN."
  value       = module.ecs.cluster_arn
}
