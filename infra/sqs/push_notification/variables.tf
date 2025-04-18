variable "env" {
  description = "The environment in which the push notification sqs will be created"
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

locals {
  fqn = "${var.env}-${var.feature}"
}
