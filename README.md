# Terraform AWS Setup

This repository contains the Terraform setup for creating AWS resources like EC2 instances, VPCs, and security groups.

## Setup Instructions

1. Install Terraform.
2. Clone this repository:
   ```bash
   git clone https://github.com/Khushneet26/terraform-aws-setup.git
   ```
3. Navigate to the project directory:
   ```bash
   cd terraform-aws-setup
   ```
4. Initialize Terraform:
   ```bash
   terraform init
   ```
5. Apply the Terraform plan to create resources:
   ```bash
   terraform apply
   ```

## Files

- `main.tf` - Terraform configuration file for AWS resources.
- `cloud-config.yml` - Cloud-init configuration for setting up the EC2 instance.

