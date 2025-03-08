data "sops_file" "line_message_api_secret" {
  source_file = "tfvars/${var.env}_line_message_api.yaml"
}
