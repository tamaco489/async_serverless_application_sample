variable "env" {
  description = "The environment in which the LINE Message API Secret Manager will be created"
  type        = string
  default     = "stg"
}

variable "project" {
  description = "The project name"
  type        = string
  default     = "async-serverless-app"
}

locals {
  fqn                        = "${var.env}-${var.project}"
  line_message_api_secret_id = "${var.project}/${var.env}/line-message-api"
}
