terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
  required_version = "~> 1.1"
}

provider "aws" {
  region = "us-west-2"
}
