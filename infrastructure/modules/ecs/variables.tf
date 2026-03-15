variable "name_prefix" {
  description = "Prefix used for ECS resources."
  type        = string
}

variable "aws_region" {
  description = "AWS region for this ECS stack instance."
  type        = string
}

variable "candidate_email" {
  description = "Candidate email used in verification payloads."
  type        = string
}

variable "github_repo_url" {
  description = "Repository URL included in verification payloads."
  type        = string
}

variable "verification_sns_topic_arn" {
  description = "Pre-existing SNS topic ARN used for candidate verification."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where ECS resources are deployed."
  type        = string
}
