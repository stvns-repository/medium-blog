terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    # Replace with the exact bucket name outputted by your CF template
    bucket         = "784079396645-lab03-us-west-2" 
    key            = "lab-03/terraform.tfstate"
    region         = "us-west-2" # Update to match your region
    encrypt        = true
  }
}

provider "aws" {
  region = "us-west-2" # Update to match your region
}

