resource "aws_cognito_user_pool" "auth" {
  name                     = "${var.name_prefix}-auth"
  auto_verified_attributes = ["email"]

  admin_create_user_config {
    allow_admin_create_user_only = true
  }

  password_policy {
    minimum_length                   = 12
    require_lowercase                = true
    require_numbers                  = true
    require_symbols                  = true
    require_uppercase                = true
    temporary_password_validity_days = 7
  }
}

resource "aws_cognito_user_pool_client" "auth" {
  name         = "${var.name_prefix}-auth-client"
  user_pool_id = aws_cognito_user_pool.auth.id

  generate_secret                      = false
  explicit_auth_flows                  = ["ALLOW_USER_PASSWORD_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]
  prevent_user_existence_errors        = "ENABLED"
  supported_identity_providers         = ["COGNITO"]
  enable_token_revocation              = true
  allowed_oauth_flows_user_pool_client = false
}

resource "aws_cognito_user" "test_user" {
  user_pool_id   = aws_cognito_user_pool.auth.id
  username       = var.candidate_email
  message_action = "SUPPRESS"
  password       = var.test_user_password

  attributes = {
    email          = var.candidate_email
    email_verified = "true"
  }
}
