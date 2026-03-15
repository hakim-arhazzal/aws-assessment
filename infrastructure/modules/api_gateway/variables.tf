variable "name_prefix" {
  description = "Prefix used for API Gateway resources."
  type        = string
}

variable "cognito_user_pool_client_id" {
  description = "Cognito user pool client ID used as the JWT audience."
  type        = string
}

variable "cognito_jwt_issuer" {
  description = "JWT issuer URL for the Cognito user pool."
  type        = string
}

variable "routes" {
  description = "Route definitions mapping API route keys to Lambda integrations and permissions."
  type = list(object({
    name                 = string
    route_key            = string
    lambda_invoke_arn    = string
    lambda_function_name = string
    integration_method   = optional(string, "POST")
  }))

  validation {
    condition     = length(var.routes) > 0
    error_message = "At least one API route definition is required."
  }

  validation {
    condition     = length(distinct([for route in var.routes : route.name])) == length(var.routes)
    error_message = "Each route.name must be unique."
  }

  validation {
    condition     = length(distinct([for route in var.routes : route.route_key])) == length(var.routes)
    error_message = "Each route.route_key must be unique."
  }
}
