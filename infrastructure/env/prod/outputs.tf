output "cognito_user_pool_id" {
  description = "Cognito User Pool ID created in us-east-1."
  value       = module.cognito.user_pool_id
}

output "cognito_user_pool_client_id" {
  description = "Cognito User Pool Client ID used for USER_PASSWORD_AUTH."
  value       = module.cognito.user_pool_client_id
}

output "test_username" {
  description = "Username for the generated Cognito test user."
  value       = module.cognito.test_username
}

output "regional_api_endpoints" {
  description = "Base API endpoints for each deployed region."
  value = {
    us-east-1 = module.compute_data_us_east_1.api_endpoint
    eu-west-1 = module.compute_data_eu_west_1.api_endpoint
  }
}

output "regional_greet_urls" {
  description = "GET /greet endpoints per region."
  value = {
    us-east-1 = module.compute_data_us_east_1.greet_url
    eu-west-1 = module.compute_data_eu_west_1.greet_url
  }
}

output "regional_dispatch_urls" {
  description = "POST /dispatch endpoints per region."
  value = {
    us-east-1 = module.compute_data_us_east_1.dispatch_url
    eu-west-1 = module.compute_data_eu_west_1.dispatch_url
  }
}
