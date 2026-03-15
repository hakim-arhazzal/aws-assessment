output "vpc_id" {
  description = "VPC ID for the regional stack."
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs used by regional ECS tasks."
  value       = aws_subnet.public[*].id
}
