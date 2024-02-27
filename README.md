---
Title: EKS Cluster using Terraform
Description: Setup EKS aws eks cluster using Terraform
---

## Introduction
- Create VPC
- Create EC2 Key pair that will be used for connecting to Host and EKS Node Group EC2 VM Instances
- Create eks nodes ec2 securitygroup and instances
- Create eks cluster iam role
- Create eks nodegroup iam role
- Create EKS Cluster
- Create Public EKS Node Group
- Create Private EKS Node Group
- Create Certificate and make DNS entry to Route53



## Create EC2 Key pair and save it
- Go to Services -> EC2 -> Network & Security -> Key Pairs -> Create Key Pair
- **Name:** eks-terraform-key
- **Key Pair Type:** RSA (leave to defaults)
- **Private key file format:** .pem
- Click on **Create key pair**
- COPY the downloaded key pair to `private-key` folder
- Provide permissions as `chmod 400 keypair-name`
```t
# Provider Permissions to EC2 Key Pair
cd private-key
chmod 400 eks-terraform-key.pem
```

## Terraform Commands
```t
# Terraform Initialize
terraform init

# Terraform Validate
terraform validate

# Terraform plan
terraform plan

# Terraform Apply
terraform apply -auto-approve

# Verify Outputs on the CLI or using below command
terraform output
```

## Verify the following Services using AWS Management Console
1. Go to Services -> Elastic Kubernetes Service -> Clusters
2. Verify the following
   - Overview
   - Workloads
   - Configuration
     - Details
     - Compute
     - Networking
     - Add-Ons
     - Authentication
     - Logging
     - Update history
     - Tags

## AWS CLI
- [Install AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

## kubectl CLI
- [Install kubectl CLI](https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html)

## Configure kubeconfig for kubectl
```t
# Configure kubeconfig for kubectl
aws eks --region <region-code> update-kubeconfig --name <cluster_name>
aws eks --region eu-central-1 update-kubeconfig --name dev-eks-01

# List Worker Nodes
kubectl get nodes
kubectl get nodes -o wide

# Verify Services
kubectl get svc

# Create Service account and secret for permissions
kubectl apply -f serviceacc_secret.yaml
```

## Verify Namespaces and Resources in Namespaces
```t
# Verify Namespaces
kubectl get namespaces
kubectl get ns 
Observation: 4 namespaces will be listed by default
1. kube-node-lease
2. kube-public
3. default
4. kube-system

# Verify Resources in kube-node-lease namespace
kubectl get all -n kube-node-lease

# Verify Resources in kube-public namespace
kubectl get all -n kube-public

# Verify Resources in default namespace
kubectl get all -n default
Observation: 
1. Kubernetes Service: Cluster IP Service for Kubernetes Endpoint

# Verify Resources in kube-system namespace
kubectl get all -n kube-system
Observation: 
1. Kubernetes Deployment: coredns
2. Kubernetes DaemonSet: aws-node, kube-proxy
3. Kubernetes Service: kube-dns
4. Kubernetes Pods: coredns, aws-node, kube-proxy
```

## Verify pods in kube-system namespace
```t
# Verify System pods in kube-system namespace
kubectl get pods # Nothing in default namespace
kubectl get pods -n kube-system
kubectl get pods -n kube-system -o wide

# Verify Daemon Sets in kube-system namespace
kubectl get ds -n kube-system
Observation: The below two daemonsets will be running
1. aws-node
2. kube-proxy

# Describe aws-node Daemon Set
kubectl describe ds aws-node -n kube-system
Observation: 
1. Reference "Image" value it will be the ECR Registry URL 

# Describe kube-proxy Daemon Set
kubectl describe ds kube-proxy -n kube-system
1. Reference "Image" value it will be the ECR Registry URL 

# Describe coredns Deployment
kubectl describe deploy coredns -n kube-system
```