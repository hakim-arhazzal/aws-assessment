variable "name_prefix" {
  description = "Prefix used for Cognito resources."
  type        = string
}

variable "candidate_email" {
  description = "Email used for Cognito test user creation."
  type        = string
}

variable "test_user_password" {
  description = "Password for the Cognito test user."
  type        = string
  sensitive   = true
}
