variable "env" {
  description = "The environment in which the VPC Endpoint will be created"
  type        = string
  default     = "stg"
}

variable "project" {
  description = "The project name"
  type        = string
  default     = "async-serverless-app"
}

variable "feature" {
  description = "The service name"
  type        = string
  default     = "vpc-endpoint"
}

locals {
  fqn = "${var.env}-${var.project}"
}
