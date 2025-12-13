provider "aws" {
  region = var.region
}

# Create VPC using AWS VPC Module
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "4.0.2"

  name                 = "${var.project_name}-vpc"
  cidr                 = var.vpc_cidr
  azs                  = ["${var.region}a", "${var.region}b"]
  private_subnets      = var.private_subnets
  public_subnets       = var.public_subnets
  enable_nat_gateway   = true
  single_nat_gateway   = true
}

# IAM role for EKS
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "${var.project_name}-eks"
  cluster_version = "1.29"
  subnets         = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id

  cluster_enabled_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  manage_aws_auth = true

  eks_managed_node_groups = {
    default = {
      desired_capacity = var.desired_capacity
      min_size         = var.min_size
      max_size         = var.max_size
      instance_types   = [var.node_instance_type]
      key_name         = null
    }
  }

  node_groups_tags = {
    "Name" = "${var.project_name}-eks-node"
  }

  # IAM roles for least privilege will be created automatically by module
}

# Optional: IAM role for GitHub Actions OIDC (least privilege)
resource "aws_iam_role" "github_actions" {
  name = "${var.project_name}-github-actions-eks-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })
}

data "aws_caller_identity" "current" {}
