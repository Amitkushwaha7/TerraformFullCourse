# EKS Static Website

Static website deployed on AWS EKS cluster using Docker and Kubernetes.

## Files

- `index.html` - Static website homepage
- `Dockerfile` - Container image definition
- `deployment.yaml` - Kubernetes Deployment manifest
- `service.yaml` - Kubernetes Service manifest (LoadBalancer)

## Build Docker Image

```bash
# Build the image
docker build -t demo-website:latest .

# Run locally for testing
docker run -d -p 8080:80 demo-website:latest

# Test
curl http://localhost:8080
```

## Tag and Push to ECR

```bash
# Login to ECR
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <account-id>.dkr.ecr.us-east-1.amazonaws.com

# Create ECR repository
aws ecr create-repository --repository-name demo-website --region us-east-1

# Tag image
docker tag demo-website:latest <account-id>.dkr.ecr.us-east-1.amazonaws.com/demo-website:latest

# Push to ECR
docker push <account-id>.dkr.ecr.us-east-1.amazonaws.com/demo-website:latest
```

## Deploy to EKS

### Step 1: Update deployment.yaml with your ECR image URL
```bash
# Edit deployment.yaml and replace placeholders:
# <ACCOUNT_ID> - Your AWS account ID
# <REGION> - Your AWS region (e.g., us-east-1)

# You can get these from terraform outputs:
cd ../terraform
terraform output ecr_repository_url
```

### Step 2: Configure kubectl
```bash
# Replace <REGION> and <CLUSTER_NAME> with your values
aws eks --region <REGION> update-kubeconfig --name <CLUSTER_NAME>

# Or use terraform output
cd ../terraform
$(terraform output -raw configure_kubectl)
```

### Step 3: Deploy to Kubernetes
```bash
cd ../demo-website
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml

# Check deployment status
kubectl get deployments
kubectl get pods
kubectl get svc demo-website
```

### Step 4: Expose the Application

**Option 1: LoadBalancer Service (Recommended for public access)**
```bash
kubectl expose deployment demo-website --type=LoadBalancer --name=demo-website --port=80 --target-port=80

# Wait for external IP (1-3 minutes)
kubectl get svc demo-website -o wide

# Access via the EXTERNAL-IP or DNS name
```

**Option 2: NodePort Service**
```bash
kubectl expose deployment demo-website --type=NodePort --name=demo-website --port=80 --target-port=80

# Get node IP and port
kubectl get nodes -o wide
kubectl get svc demo-website

# Access via http://<NODE_IP>:<NODE_PORT>
# Note: Ensure security group allows the NodePort
```

**Option 3: Port Forward (Local testing only)**
```bash
kubectl port-forward deployment/demo-website 8080:80

# Access via http://localhost:8080
```

## Features

- ✅ Nginx Alpine base (small image size ~25MB)
- ✅ Static website served from `/`
- ✅ Simple Docker build and run

## Image Size

- Base nginx:alpine: ~23MB
- Final image: ~25MB

## Port

- Container listens on port 80
- Health check: `http://localhost/`
