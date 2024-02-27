# Create AWS EKS Cluster
resource "aws_eks_cluster" "eks_cluster" {
  name     = "${local.name}-${var.cluster_name}"
  role_arn = aws_iam_role.eks_master_role.arn
  version  = var.cluster_version

  vpc_config {
    subnet_ids              = module.vpc.public_subnets
    endpoint_private_access = var.cluster_endpoint_private_access
    endpoint_public_access  = var.cluster_endpoint_public_access
    public_access_cidrs     = var.cluster_endpoint_public_access_cidrs
  }

  kubernetes_network_config {
    service_ipv4_cidr = var.cluster_service_ipv4_cidr
  }

  # Enable EKS Cluster Control Plane Logging
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.eks-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks-AmazonEKSVPCResourceController,
  ]
}

# Addon: VPC CNI
resource "aws_eks_addon" "vpc_cni" {
  cluster_name           = aws_eks_cluster.eks_cluster.name
  addon_name             = "vpc-cni"
  addon_version          = "v1.14.1-eksbuild.1"  # Replace with the desired version of the addon
  #service_account_role_arn = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}

# Addon: Kube Proxy
resource "aws_eks_addon" "kube_proxy" {
  cluster_name           = aws_eks_cluster.eks_cluster.name
  addon_name             = "kube-proxy"
  addon_version          = "v1.29.0-eksbuild.1"  # Replace with the desired version of the addon
  #service_account_role_arn = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}

# Addon: EKS Pod Identity Webhook
resource "aws_eks_addon" "pod_identity" {
  cluster_name           = aws_eks_cluster.eks_cluster.name
  addon_name             = "eks-pod-identity-agent"
  addon_version          = "v1.0.0-eksbuild.1"  # Replace with the desired version of the addon
  #service_account_role_arn = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}

# Addon: CoreDNS
resource "aws_eks_addon" "coredns" {
  cluster_name           = aws_eks_cluster.eks_cluster.name
  addon_name             = "coredns"
  addon_version          = "v1.11.1-eksbuild.4"  # Replace with the desired version of the addon
  #service_account_role_arn = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}
