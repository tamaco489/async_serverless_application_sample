data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "${var.env}-async-serverless-application-tfstate"
    key    = "network/terraform.tfstate"
  }
}

data "terraform_remote_state" "shop_api_service" {
  backend = "s3"
  config = {
    bucket = "${var.env}-async-serverless-application-tfstate"
    key    = "service/api/shop/terraform.tfstate"
  }
}

data "terraform_remote_state" "batch_push_notification_service" {
  backend = "s3"
  config = {
    bucket = "${var.env}-async-serverless-application-tfstate"
    key    = "service/batch/push_notification/terraform.tfstate"
  }
}
