locals {
  cognito_jwt_issuer = "https://cognito-idp.us-east-1.amazonaws.com/${aws_cognito_user_pool.auth.id}"
}
