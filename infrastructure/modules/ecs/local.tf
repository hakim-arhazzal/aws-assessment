locals {
  ecs_sns_message = jsonencode({
    email  = var.candidate_email
    source = "ECS"
    region = var.aws_region
    repo   = var.github_repo_url
  })
}
