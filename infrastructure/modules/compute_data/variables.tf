variable "name_prefix" {
  description = "Prefix used for regional resources."
  type        = string
}

variable "aws_region" {
  description = "AWS region for this stack instance."
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

variable "cognito_user_pool_client_id" {
  description = "Cognito user pool client ID used as the JWT audience."
  type        = string
}

variable "cognito_jwt_issuer" {
  description = "JWT issuer URL for the us-east-1 Cognito user pool."
  type        = string
}
