variable "env" {
  description = "The environment in which the push notification batch lambda will be created"
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
  default     = "push-notification"
}

variable "region" {
  description = "The region in which the push notification batch lambda will be created"
  type        = string
  default     = "ap-northeast-1"
}

locals {
  fqn = "${var.env}-${var.feature}"
}
