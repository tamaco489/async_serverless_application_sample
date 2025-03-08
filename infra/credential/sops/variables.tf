variable "env" {
  description = "The environment in which the kms will be created"
  type        = string
  default     = "stg"
}

variable "project" {
  description = "The project name"
  type        = string
  default     = "async-serverless-app"
}

locals {
  fqn = "${var.env}-${var.project}"
}
