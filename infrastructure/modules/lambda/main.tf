resource "aws_lambda_function" "this" {
  function_name    = "${var.name_prefix}-${var.function_name_suffix}"
  filename         = data.archive_file.lambda_package.output_path
  source_code_hash = data.archive_file.lambda_package.output_base64sha256
  role             = aws_iam_role.lambda.arn
  handler          = var.handler
  runtime          = var.runtime
  timeout          = var.timeout

  environment {
    variables = var.environment
  }
}

