terraform {
  required_providers {
    # Adding AWS and Gitlab providers.
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = "~> 18.0"
    }
  }
	# S3 backend to store our terraform state file
	# Go back to your CloudFormation template and grab the S3BucketName value
  backend "s3" {
    bucket       = "<Grab the TFStateBucket value>"
    key          = "production.tfstate"
    region       = "us-west-2"
    use_lockfile = true
  }
}

provider "aws" {
  region = "us-west-2"
}

provider "gitlab" {
  base_url = var.gitlab_url
  token    = var.gitlab_token
  insecure = true
}
