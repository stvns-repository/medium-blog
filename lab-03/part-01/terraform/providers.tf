terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    # Keep these keys blank! We will inject them dynamically on the host.
    bucket         = ""
    key            = "lab-03/terraform.tfstate"
    region         = "us-west-2" 
    encrypt        = true
  }
}

provider "aws" {
  region = "us-west-2"
}
