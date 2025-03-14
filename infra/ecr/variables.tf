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

locals {
  fqn                     = "${var.env}-${var.project}"
  shop_api                = "${var.env}-shop-api"
  gem_api                 = "${var.env}-gem-api"
  push_notification_batch = "${var.env}-push-notification-batch"
  slack_message_batch     = "${var.env}-slack-message-batch"
}
