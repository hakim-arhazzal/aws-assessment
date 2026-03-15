module "cognito" {
  source = "../../modules/cognito"

  name_prefix        = "unleash-live"
  candidate_email    = var.candidate_email
  test_user_password = var.test_user_password

  providers = {
    aws = aws
  }
}

module "compute_data_us_east_1" {
  source = "../../modules/compute_data"

  name_prefix                 = "unleash-live-us-east-1"
  aws_region                  = "us-east-1"
  candidate_email             = var.candidate_email
  github_repo_url             = var.github_repo_url
  verification_sns_topic_arn  = var.verification_sns_topic_arn
  cognito_user_pool_client_id = module.cognito.user_pool_client_id
  cognito_jwt_issuer          = module.cognito.jwt_issuer

  providers = {
    aws = aws
  }

  depends_on = [module.cognito]
}

module "compute_data_eu_west_1" {
  source = "../../modules/compute_data"

  name_prefix                 = "unleash-live-eu-west-1"
  aws_region                  = "eu-west-1"
  candidate_email             = var.candidate_email
  github_repo_url             = var.github_repo_url
  verification_sns_topic_arn  = var.verification_sns_topic_arn
  cognito_user_pool_client_id = module.cognito.user_pool_client_id
  cognito_jwt_issuer          = module.cognito.jwt_issuer

  providers = {
    aws = aws.eu_west_1
  }

  depends_on = [module.cognito]
}
