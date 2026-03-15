locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 2)

  vpc_cidr_block = "10.${var.aws_region == "us-east-1" ? 10 : 20}.0.0/16"
}
