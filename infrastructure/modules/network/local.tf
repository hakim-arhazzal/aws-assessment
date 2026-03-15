locals {
  azs = [
    "${var.aws_region}a",
    "${var.aws_region}b",
  ]

  vpc_cidr_block = "10.${var.aws_region == "us-east-1" ? 10 : 20}.0.0/16"
}
