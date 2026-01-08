# Day 17: Blue-Green Deployment with AWS Elastic Beanstalk

This project demonstrates a **Blue-Green Deployment** strategy using AWS Elastic Beanstalk and Terraform. It replicates the "deployment slots" functionality found in other PaaS offerings (like AWS App Service) to achieve zero-downtime deployments.

## Project Overview

Blue-Green deployment is a technique that reduces downtime and risk by running two identical production environments called Blue and Green.

*   **Blue Environment (Production):** Hosts the current live version (v1.0).
*   **Green Environment (Staging):** Hosts the new version (v2.0).
*   **The Swap:** Once the Green environment is tested and ready, you instantly swap the URLs (CNAMEs). Green becomes Production, and Blue becomes Staging.

## Architecture

The Terraform configuration provisions the following resources:

*   **Elastic Beanstalk Application:** The logical container `my-app-bluegreen`.
*   **S3 Bucket:** Stores application artifacts (`app-v1.zip` and `app-v2.zip`).
*   **Two Independent Environments:**
    *   `my-app-bluegreen-blue`: Running **v1.0** (Blue Theme).
    *   `my-app-bluegreen-green`: Running **v2.0** (Green Theme).
*   **IAM Roles:** Custom roles for EC2 instances and Beanstalk service operations.

## Project Structure

```text
Day-17/terraform/
├── app-v1/                 # Source code for Version 1.0 (Blue)
├── app-v2/                 # Source code for Version 2.0 (Green)
├── blue-environments.tf    # Infrastructure for the Blue environment
├── green-environments.tf   # Infrastructure for the Green environment
├── main.tf                 # Core resources (App, S3, IAM)
├── variables.tf            # Configuration variables
├── package-apps.ps1        # PowerShell script to zip application code
├── package-apps.sh         # Bash script to zip application code (Mac/Linux)
├── swap-environments.ps1   # PowerShell script to perform the CNAME swap
└── swap-environments.sh    # Bash script to perform the CNAME swap (Mac/Linux)
```

## Getting Started

### Prerequisites

*   **Terraform** (v1.0+)
*   **AWS CLI** (configured with appropriate credentials)
*   **PowerShell** (Step 1 & 3)

### Step 1: Package Applications

Before deploying, you must package the Node.js source code into ZIP files.

**Windows (PowerShell):**
```powershell
cd terraform
.\package-apps.ps1
```

**Mac/Linux:**
```bash
cd terraform
chmod +x package-apps.sh
./package-apps.sh
```

This creates `app-v1.zip` and `app-v2.zip` in their respective directories.

### Step 2: Deploy Infrastructure

Initialize and apply the Terraform configuration.

```bash
terraform init
terraform plan
terraform apply
```

> **Note:** Deployment typically takes 15-20 minutes as AWS provisions EC2 instances, Load Balancers, and Auto Scaling Groups.

### Step 3: Verify Environments

Terraform will output the URLs for both environments.

1.  **Open the Blue URL:** You should see the **v1.0** application with a blue background.
2.  **Open the Green URL:** You should see the **v2.0** application with a green background.

At this stage, **Blue is your "Production"** and traffic is flowing to v1.0.

## Performing the Swap (Zero Downtime)

To promote v2.0 (Green) to Production, run the swap script. This command swaps the CNAME records of the two environments.

**Windows (PowerShell):**
```powershell
.\swap-environments.ps1
```

**Mac/Linux:**
```bash
chmod +x swap-environments.sh
./swap-environments.sh
```

**What happens next?**
1.  The script identifies the environment names.
2.  It executes `aws elasticbeanstalk swap-environment-cnames`.
3.  Within seconds/minutes, the URL that previously pointed to Blue (v1.0) will now serve Green (v2.0).
4.  No connections are dropped; users experience a seamless transition.

## Configuration

You can customize the deployment by modifying `variables.tf`:

| Variable | Default | Description |
| :--- | :--- | :--- |
| `aws_region` | `us-east-1` | Target AWS Region |
| `app_name` | `my-app-bluegreen` | Name of the Beanstalk Application |
| `instance_type` | `t3.micro` | EC2 Instance size |
| `solution_stack_name` | `64bit Amazon Linux 2023...` | Platform version (Node.js 20) |

## Clean Up

To avoid incurring costs for the Load Balancers and EC2 instances, destroy the infrastructure when finished.

```bash
terraform destroy
```

## 🤝 Contributing

Feel free to submit issues, fork the repository, and create pull requests for any improvements.

Happy Deploying! 🚀

