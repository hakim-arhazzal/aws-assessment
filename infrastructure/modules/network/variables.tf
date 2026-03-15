variable "name_prefix" {
  description = "Prefix used for network resources."
  type        = string
}

variable "aws_region" {
  description = "AWS region used to derive a deterministic CIDR per stack instance."
  type        = string
}
