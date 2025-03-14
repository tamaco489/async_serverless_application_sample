variable "env" {
  description = "The environment in which the slack message batch lambda will be created"
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
  default     = "slack-message"
}

variable "region" {
  description = "The region in which the slack message batch lambda will be created"
  type        = string
  default     = "ap-northeast-1"
}

locals {
  fqn = "${var.env}-${var.feature}"
}
