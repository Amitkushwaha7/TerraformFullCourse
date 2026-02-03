# Day 20: EKS Cluster + Demo Website (Terraform + Kubernetes)

This project provisions a production-ready Amazon EKS cluster with Terraform and deploys a demo website to EKS.

Blog: https://dev.to/amit_kumar_7db8e36a64dd45/-day-20-terraform-custom-modules-for-eks-from-zero-to-production-4j92

## Contents

- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Quick Start (Manual)](#quick-start-manual)
- [Manual Steps (Infrastructure)](#manual-steps-infrastructure)
- [Manual Steps (Application)](#manual-steps-application)
- [Configuration Options](#configuration-options)
- [Security Notes](#security-notes)
- [Cleanup](#cleanup)
- [Troubleshooting](#troubleshooting)
- [References](#references)

## Architecture

![Architecture Diagram](Assets/architecture_diagram.jpg)

### Visual Diagram

```
External Users → Internet Gateway → AWS NLB → Kubernetes Service → Demo Website Pods
```

### Key Components

- **VPC**: Public and private subnets across 3 availability zones (10.0.0.0/16)
- **EKS Cluster**: Kubernetes 1.31 with AWS-managed control plane
- **Node Groups**:
  - On-Demand nodes (t3.medium): General-purpose compute
  - Spot nodes (c5.large): Cost-optimized compute
- **Control Plane**: etcd encrypted with KMS, API server secured
- **Add-ons**: CoreDNS, kube-proxy, VPC CNI, EBS CSI driver
- **IRSA**: IAM Roles for Service Accounts for fine-grained pod permissions
- **Networking**: NAT Gateway for outbound traffic, Internet Gateway for public access
- **Observability**: CloudWatch Logs and CloudWatch Metrics integration

## Prerequisites

1. **AWS Account** with required permissions
2. **AWS CLI** installed and configured
3. **Terraform** >= 1.3
4. **kubectl**
5. **Docker**

## Quick Start (Manual)

Follow these steps to deploy the complete infrastructure and application:

### 1. **Initialize Terraform**

```bash
cd terraform
terraform init
```

### 2. **Review the plan**

```bash
terraform plan
```

### 3. **Apply**

```bash
terraform apply
```

### 4. **Configure kubectl**

```bash
$(terraform output -raw configure_kubectl)
```

### 5. **Deploy Application**

See [demo-website/README.md](demo-website/README.md) for detailed instructions.

Quick steps:

```bash
cd ../demo-website

# Build Docker image
docker build -t demo-website .

# Get ECR details from terraform outputs
cd ../terraform
terraform output ecr_repository_url
$(terraform output -raw ecr_login_command)

# Tag and push to ECR
docker tag demo-website:latest <ECR_URL>:latest
docker push <ECR_URL>:latest

# Deploy to Kubernetes
cd ../demo-website
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml

# Get LoadBalancer URL (wait 1-3 min for provisioning)
kubectl get svc demo-website -o wide
```

### 6. **Verify Deployment**

```bash
kubectl get nodes
kubectl get pods -l app=demo-website
kubectl get deployment demo-website
kubectl get svc demo-website
```

## Configuration Options

Update values in [terraform/terraform.tfvars](terraform/terraform.tfvars):

```hcl
aws_region         = "us-east-1"
cluster_name       = "day20-eks-cluster"
kubernetes_version = "1.31"
environment        = "development"

vpc_cidr        = "10.0.0.0/16"
private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
```

## Security Notes

- State files are ignored by default via [../.gitignore](.gitignore)
- Demo deployment includes resource limits and health checks in [demo-website/deployment.yaml](demo-website/deployment.yaml)
- IRSA is enabled for pod-level permissions

## Cleanup

**Important:** Delete Kubernetes LoadBalancer service first to remove AWS load balancer, then destroy infrastructure.

```bash
# Delete Kubernetes resources
kubectl delete svc demo-website
kubectl delete deployment demo-website

# Destroy Terraform infrastructure
cd terraform
terraform destroy
```

## Troubleshooting

### Cannot connect to the cluster
```bash
aws sts get-caller-identity
aws eks --region us-east-1 update-kubeconfig --name day20-eks-cluster
```

### Nodes not joining
```bash
aws eks describe-nodegroup --cluster-name day20-eks-cluster --nodegroup-name <node-group-name>
```

### Image pull errors
Verify the ECR image URL in [demo-website/deployment.yaml](demo-website/deployment.yaml) matches your account ID.

## References

- [Blog: Day 20 - Terraform Custom Modules for EKS (Dev.to)](https://dev.to/amit_kumar_7db8e36a64dd45/-day-20-terraform-custom-modules-for-eks-from-zero-to-production-4j92)
- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Terraform EKS Module](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest)
- [AWS EKS Documentation](https://docs.aws.amazon.com/eks/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
