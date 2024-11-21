terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}


provider "azurerm" {
  features {}
  subscription_id = var.subId
}
variable "subId" {
  default = "f5cdf00f-31a8-4de8-a6ed-ce99628b62a7"
}



provider "aws" {
  region                   = "us-east-1"
  shared_config_files      = ["C:/Users/46987777802/.aws/config"]
  shared_credentials_files = ["C:/Users/46987777802/.aws/credentials"]

  default_tags {
    tags = {
      owner      = "Gustavo"
      managed-by = "Terraform134"
    }


  }
}