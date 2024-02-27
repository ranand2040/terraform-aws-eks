# Define Local Values in Terraform
locals {
  owners      = var.environment
  environment = var.environment
  name        = var.environment
  common_tags = {
    owners      = local.environment
    environment = local.environment
  }
  eks_cluster_name = "${local.name}-${var.cluster_name}"
} 