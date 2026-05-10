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
	# Go back to your CloudFormation template and grab the TFStateBucket value
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

# Added for part 4
# This data source gets a temporary token to "log in" to EKS
data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
  }
}

# Helm provider
provider "helm" {
  kubernetes = {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
      command     = "aws"
    }
  }
}
