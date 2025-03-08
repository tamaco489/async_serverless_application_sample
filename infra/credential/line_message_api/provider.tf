provider "aws" {}

terraform {
  required_version = "1.9.5"
  backend "s3" {
    bucket = "stg-async-serverless-application-tfstate"
    key    = "credential/line_message_api/terraform.tfstate"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
    sops = {
      source  = "carlpett/sops"
      version = ">=1.0.0"
    }
  }
}
