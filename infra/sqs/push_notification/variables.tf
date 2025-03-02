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

variable "queue_config" {
  description = "The push notification queue config"
  type = object({
    max_message_size_kb        = number
    visibility_timeout_minutes = number
    message_retention_days     = number
    max_receive_count          = number
  })
  default = {
    max_message_size_kb        = 256
    visibility_timeout_minutes = 15
    message_retention_days     = 4
    max_receive_count          = 5
  }
}

variable "dlq_config" {
  description = "The push notification dlq config"
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

  queue_max_message_size           = var.queue_config.max_message_size_kb * 1024
  queue_visibility_timeout_seconds = var.queue_config.visibility_timeout_minutes * 60
  queue_message_retention_seconds  = var.queue_config.message_retention_days * 24 * 60 * 60
  max_receive_count                = var.queue_config.max_receive_count

  dlq_max_message_size           = var.dlq_config.max_message_size_kb * 1024
  dlq_visibility_timeout_seconds = var.dlq_config.visibility_timeout_minutes * 60
  dlq_message_retention_seconds  = var.dlq_config.message_retention_days * 24 * 60 * 60
}
