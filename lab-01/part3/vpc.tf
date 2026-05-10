# Part 3 - Creating base VPC for our EKS
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "eks-lab-vpc"
  cidr = "10.0.0.0/16"

  # EKS requires at least two Availability Zones
  azs             = ["us-west-2a", "us-west-2b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true # Single NAT GW -- cost-saving since this is a LAB environment.

  # These tags are CRITICAL. Without them, Kubernetes
  # won't know where to create your Load Balancers.
  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }
}
