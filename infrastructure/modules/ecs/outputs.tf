output "cluster_arn" {
  description = "Regional ECS cluster ARN."
  value       = aws_ecs_cluster.this.arn
}

output "task_definition_arn" {
  description = "Regional ECS task definition ARN."
  value       = aws_ecs_task_definition.dispatch.arn
}

output "security_group_id" {
  description = "Security group ID used by ECS task network configuration."
  value       = aws_security_group.ecs_task.id
}

output "task_execution_role_arn" {
  description = "Execution role ARN for ECS tasks."
  value       = aws_iam_role.ecs_task_execution.arn
}

output "task_role_arn" {
  description = "Task role ARN for ECS tasks."
  value       = aws_iam_role.ecs_task.arn
}
