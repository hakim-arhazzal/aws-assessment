variable "name_prefix" {
  description = "Prefix used for Lambda resources."
  type        = string
}

variable "function_name_suffix" {
  description = "Suffix appended to the function and role names (for example, greeter or dispatcher)."
  type        = string
}

variable "package_subdir" {
  description = "Lambda source package directory under infrastructure/scripts/."
  type        = string
}

variable "handler" {
  description = "Lambda handler."
  type        = string
  default     = "app.lambda_handler"
}

variable "runtime" {
  description = "Lambda runtime."
  type        = string
  default     = "python3.12"
}

variable "timeout" {
  description = "Lambda timeout in seconds."
  type        = number
}

variable "environment" {
  description = "Environment variables for the Lambda function."
  type        = map(string)
}

variable "iam_statements" {
  description = "Inline IAM statements applied to the Lambda role policy."
  type = list(object({
    actions   = list(string)
    resources = list(string)
  }))
}

