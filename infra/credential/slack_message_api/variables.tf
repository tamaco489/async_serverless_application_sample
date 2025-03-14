variable "env" {
  description = "The environment in which the Slack Message API Secret Manager will be created"
  type        = string
  default     = "stg"
}

variable "project" {
  description = "The project name"
  type        = string
  default     = "async-serverless-app"
}

locals {
  fqn                         = "${var.env}-${var.project}"
  slack_message_api_secret_id = "${var.project}/${var.env}/slack-message-api"
}
