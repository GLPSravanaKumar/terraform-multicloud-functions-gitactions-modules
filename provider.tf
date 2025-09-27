terraform {
  required_providers {
    # This is the provider configuration for Terraform.
    # It specifies the providers and their versions that Terraform will use.
    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = "1.39.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.40.0"
    }
  }
}

provider "mongodbatlas" {
  /* public_key  = var.MONGODB_ATLAS_PUBLIC_KEY
  private_key = var.MONGODB_ATLAS_PRIVATE_KEY */
}

provider "aws" {
  region = "us-east-1"
  #  profile = "optum"
  default_tags {
    tags = {
      Environment = "Dev"
      Cient       = upper("optum")
    }
  }
}



provider "azurerm" {
  features {}
  subscription_id = "1d7b8351-e118-4142-8865-634d6b506c5d"
}

