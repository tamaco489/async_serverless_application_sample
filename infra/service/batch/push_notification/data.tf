data "terraform_remote_state" "ecr" {
  backend = "s3"
  config = {
    bucket = "${var.env}-async-serverless-application-tfstate"
    key    = "ecr/terraform.tfstate"
  }
}

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "${var.env}-async-serverless-application-tfstate"
    key    = "network/terraform.tfstate"
  }
}

data "terraform_remote_state" "sqs" {
  backend = "s3"
  config = {
    bucket = "${var.env}-async-serverless-application-tfstate"
    key    = "sqs/push_notification/terraform.tfstate"
  }
}

data "terraform_remote_state" "credential_line_message_api" {
  backend = "s3"
  config = {
    bucket = "${var.env}-async-serverless-application-tfstate"
    key    = "credential/line_message_api/terraform.tfstate"
  }
}

# AWS マネージド型キー
data "aws_kms_key" "secretsmanager" {
  key_id = "alias/aws/secretsmanager"
}
