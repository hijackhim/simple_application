output "cluster_name" {
  value       = module.eks.cluster_id
  description = "EKS cluster name"
}

output "cluster_endpoint" {
  value       = module.eks.cluster_endpoint
  description = "EKS cluster endpoint"
}

output "kubeconfig_certificate_authority_data" {
  value       = module.eks.cluster_certificate_authority_data
  description = "Base64 encoded kubeconfig CA data"
}

output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "VPC ID"
}

output "public_subnets" {
  value       = module.vpc.public_subnets
  description = "Public Subnets"
}

output "private_subnets" {
  value       = module.vpc.private_subnets
  description = "Private Subnets"
}

output "node_group_role_arn" {
  value       = module.eks.node_groups["default"].iam_role_arn
  description = "Node Group IAM Role ARN"
}

output "github_actions_role_arn" {
  value       = aws_iam_role.github_actions.arn
  description = "GitHub Actions OIDC IAM Role ARN"
}
