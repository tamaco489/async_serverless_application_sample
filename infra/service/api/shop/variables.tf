variable "env" {
  description = "The environment in which the shop api lambda will be created"
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

variable "region" {
  description = "The region in which the shop api lambda will be created"
  type        = string
  default     = "ap-northeast-1"
}

locals {
  fqn = "${var.env}-${var.product}"
}
