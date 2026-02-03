# EKS Custom Modules - Demo

## Overview
This demo provisions an EKS cluster using custom Terraform modules and deploys a static demo website. Below are the exact steps used with proof screenshots at each stage.

## Architecture Overview

![Architecture Diagram](Assets/architecture_diagram.jpg)

![EKS architecture diagram (complete)](Assets/eks-architecture-diagram-complete.png)

![EKS architecture diagram](Assets/eks-architecture-diagram.jpg)

### Component Details

**VPC Network**: 10.0.0.0/16 with public (10.0.1-3/24) and private (10.0.11-13/24) subnets across 3 AZs

**EKS Cluster**: Kubernetes 1.31 with AWS-managed control plane, etcd encrypted with KMS, and 4 worker node groups for high availability

**AWS Services**:
- **ECR**: Docker image repository for the demo website
- **IAM/OIDC**: IRSA (IAM Roles for Service Accounts) for pod-level permissions
- **KMS**: Encryption for etcd and EBS volumes
- **CloudWatch**: Logs and metrics for monitoring
- **Secrets Manager**: Optional secret storage for database and API credentials

---

## Demo Steps

### Step 1: Provision Infrastructure

```bash
cd /c/Users/amitk/Projects/TerraformCourse/TerraformFullCourse/Day-20/terraform
terraform init
terraform validate
terraform plan
terraform apply
```

![Terraform validate success](Assets/terraform-validate-success.png)

![EKS node groups creating (Terraform output)](Assets/terraform-eks-node-groups-creating.png)

---

### Step 2: Configure kubectl

```bash
terraform output -raw configure_kubectl
```

![kubectl get nodes](Assets/kubectl-get-nodes.png)

![kubectl get nodes -o wide](Assets/kubectl-get-nodes-wide.png)

![EKS cluster info](Assets/aws-console-eks-cluster-info.png)

![EC2 instances (worker nodes)](Assets/aws-console-ec2-instances.png)

![VPC dashboard](Assets/aws-console-vpc-dashboard.png)

---

### Step 3: Build and Push Docker Image

```bash
cd ../demo-website
docker build -t demo-website:latest .
```

![Docker build demo website](Assets/docker-build-demo-website.png)

---

```bash
cd ../terraform
terraform output ecr_repository_url
terraform output -raw ecr_login_command

docker tag demo-website:latest <ECR_URL>:latest
docker push <ECR_URL>:latest
```

![Docker tag demo website](Assets/docker-tag-demo-website.png)

![Docker push demo website](Assets/docker-push-demo-website.png)

![ECR push commands](Assets/aws-ecr-push-commands.png)

![ECR images page](Assets/aws-console-ecr-images.png)

---

### Step 4: Deploy Application to EKS

```bash
cd ../demo-website
kubectl apply -f deployment.yaml
```

![kubectl apply deployment](Assets/kubectl-apply-deployment.png)

---

```bash
kubectl apply -f service.yaml
kubectl get svc demo-website -o wide
```

![kubectl get service -o wide](Assets/kubectl-get-service-wide.png)

![Demo website homepage](Assets/demo-website-homepage.png)

![EKS workloads](Assets/aws-console-eks-workloads.png)

---

### Step 5: Cleanup

```bash
kubectl delete svc demo-website
```

![kubectl delete service](Assets/kubectl-delete-service.png)

---

```bash
kubectl delete deployment demo-website
```

![kubectl delete deployment](Assets/kubectl-delete-deployment.png)

---

```bash
cd ../terraform
terraform destroy
```

![Terraform destroy complete](Assets/terraform-destroy-complete.png)

---

## Summary

This demo demonstrated:
- Provisioning a production-ready EKS cluster with Terraform custom modules
- Building and pushing Docker images to ECR
- Deploying containerized applications to Kubernetes
- Exposing services with LoadBalancers
- Cleaning up all resources

All resources are managed by Infrastructure as Code, enabling repeatable and auditable deployments.
