output "user_pool_id" {
  description = "Cognito User Pool ID."
  value       = aws_cognito_user_pool.auth.id
}

output "user_pool_client_id" {
  description = "Cognito User Pool Client ID for USER_PASSWORD_AUTH."
  value       = aws_cognito_user_pool_client.auth.id
}

output "test_username" {
  description = "Username of the generated Cognito test user."
  value       = aws_cognito_user.test_user.username
}

output "jwt_issuer" {
  description = "JWT issuer URL for the Cognito User Pool."
  value       = local.cognito_jwt_issuer
}
