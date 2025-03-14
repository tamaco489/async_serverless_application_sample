data "sops_file" "slack_message_api_secret" {
  source_file = "tfvars/${var.env}_slack_message_api.yaml"
}
