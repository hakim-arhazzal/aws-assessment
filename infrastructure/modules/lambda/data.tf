data "archive_file" "lambda_package" {
  type        = "zip"
  source_dir  = "${path.module}/../../scripts/${var.package_subdir}"
  output_path = "${path.module}/${var.function_name_suffix}.zip"
}

