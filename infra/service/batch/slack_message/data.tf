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

data "terraform_remote_state" "dynamodb" {
  backend = "s3"
  config = {
    bucket = "${var.env}-async-serverless-application-tfstate"
    key    = "dynamodb/terraform.tfstate"
  }
}

data "terraform_remote_state" "sqs" {
  backend = "s3"
  config = {
    bucket = "${var.env}-async-serverless-application-tfstate"
    key    = "sqs/slack_message/terraform.tfstate"
  }
}

data "terraform_remote_state" "credential_slack_message_api" {
  backend = "s3"
  config = {
    bucket = "${var.env}-async-serverless-application-tfstate"
    key    = "credential/slack_message_api/terraform.tfstate"
  }
}

data "aws_kms_key" "secretsmanager" {
  key_id = "alias/aws/secretsmanager"
}
