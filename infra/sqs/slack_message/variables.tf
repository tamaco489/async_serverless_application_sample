variable "env" {
  description = "The environment in which the slack message sqs will be created"
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

variable "dlq_config" {
  description = "The slack message dlq config"
  type = object({
    max_message_size_kb        = number
    visibility_timeout_minutes = number
    message_retention_days     = number
  })
  default = {
    max_message_size_kb        = 256
    visibility_timeout_minutes = 15
    message_retention_days     = 7
  }
}

locals {
  fqn = "${var.env}-${var.feature}"

  dlq_max_message_size           = var.dlq_config.max_message_size_kb * 1024
  dlq_visibility_timeout_seconds = var.dlq_config.visibility_timeout_minutes * 60
  dlq_message_retention_seconds  = var.dlq_config.message_retention_days * 24 * 60 * 60
}
