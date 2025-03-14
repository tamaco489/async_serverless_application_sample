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
