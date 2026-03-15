variable "candidate_email" {
  description = "Email used for Cognito test user creation and verification payloads."
  type        = string
}

variable "github_repo_url" {
  description = "Repository URL included in verification payloads."
  type        = string
}

variable "test_user_password" {
  description = "Password for the Cognito test user."
  type        = string
  sensitive   = true
}

variable "verification_sns_topic_arn" {
  description = "Pre-existing SNS topic ARN used by Lambda and ECS."
  type        = string
  default     = "arn:aws:sns:us-east-1:637226132752:Candidate-Verification-Topic"
}

