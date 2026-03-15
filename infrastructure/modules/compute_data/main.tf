module "network" {
  source = "../network"

  name_prefix = var.name_prefix
  aws_region  = var.aws_region
}

resource "aws_dynamodb_table" "greeting_logs" {
  name         = "${var.name_prefix}-GreetingLogs"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }
}

module "ecs" {
  source = "../ecs"

  name_prefix                = var.name_prefix
  aws_region                 = var.aws_region
  candidate_email            = var.candidate_email
  github_repo_url            = var.github_repo_url
  verification_sns_topic_arn = var.verification_sns_topic_arn
  vpc_id                     = module.network.vpc_id
}

module "lambda_greeter" {
  source = "../lambda"

  name_prefix          = var.name_prefix
  function_name_suffix = "greeter"
  package_subdir       = "greeter_lambda"
  timeout              = 15
  environment = {
    DYNAMODB_TABLE  = aws_dynamodb_table.greeting_logs.name
    SNS_TOPIC_ARN   = var.verification_sns_topic_arn
    CANDIDATE_EMAIL = var.candidate_email
    AWS_REGION_NAME = var.aws_region
    GITHUB_REPO_URL = var.github_repo_url
  }
  iam_statements = [
    {
      actions   = ["dynamodb:PutItem"]
      resources = [aws_dynamodb_table.greeting_logs.arn]
    },
    {
      actions   = ["sns:Publish"]
      resources = [var.verification_sns_topic_arn]
    }
  ]
}


module "lambda_dispatcher" {
  source               = "../lambda"
  name_prefix          = var.name_prefix
  function_name_suffix = "dispatcher"
  package_subdir       = "dispatcher_lambda"
  timeout              = 20
  environment = {
    ECS_CLUSTER_ARN     = module.ecs.cluster_arn
    TASK_DEFINITION_ARN = module.ecs.task_definition_arn
    SUBNET_IDS          = join(",", module.network.public_subnet_ids)
    SECURITY_GROUP_ID   = module.ecs.security_group_id
    AWS_REGION_NAME     = var.aws_region
  }
  iam_statements = [
    {
      actions   = ["ecs:RunTask"]
      resources = [module.ecs.task_definition_arn]
    },
    {
      actions   = ["iam:PassRole"]
      resources = [module.ecs.task_execution_role_arn, module.ecs.task_role_arn]
    }
  ]
}

module "api_gateway" {
  source = "../api_gateway"

  name_prefix                 = var.name_prefix
  cognito_user_pool_client_id = var.cognito_user_pool_client_id
  cognito_jwt_issuer          = var.cognito_jwt_issuer
  routes = [
    {
      name                 = "greeter"
      route_key            = "GET /greet"
      lambda_invoke_arn    = module.lambda_greeter.invoke_arn
      lambda_function_name = module.lambda_greeter.function_name
    },
    {
      name                 = "dispatcher"
      route_key            = "POST /dispatch"
      lambda_invoke_arn    = module.lambda_dispatcher.invoke_arn
      lambda_function_name = module.lambda_dispatcher.function_name
    }
  ]
}
