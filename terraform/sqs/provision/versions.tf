terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.63"
    }
    template = {
      source = "hashicorp/template"
    }
  }
  required_version = "~> 1.1"
}

provider "aws" {
  region = "us-west-2"
}
