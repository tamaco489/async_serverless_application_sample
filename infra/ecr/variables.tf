variable "env" {
  description = "The environment in which the ecr will be created"
  type        = string
  default     = "stg"
}

variable "project" {
  description = "The project name"
  type        = string
  default     = "async-serverless-app"
}

variable "product" {
  description = "The product name"
  type        = string
  default     = "shop"
}

locals {
  fqn = "${var.env}-${var.product}"
}
