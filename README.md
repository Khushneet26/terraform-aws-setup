# Terraform AWS Setup

This repository contains Terraform configurations for deploying infrastructure on AWS. Follow the steps below to set up your environment.
## Generating SSH Key Pair
To create a new SSH key pair for Terraform, use the following command:
```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/my_terraform_key
```
This generates:
- **`my_terraform_key`** (private key)
- **`my_terraform_key.pub`** (public key, to be added to AWS)

Add the SSH key to GitHub (if required):
```bash
cat ~/.ssh/my_terraform_key.pub
```
Copy the contents and add them to GitHub under **Settings > SSH and GPG keys**.

## Cloning the Repository
Clone this repository using SSH:
```bash
git clone git@github.com:Khushneet26/terraform-aws-setup.git
cd terraform-aws-setup
```

## Initializing Terraform
Run the following command to initialize Terraform and download provider plugins:
```bash
terraform init
```

## Formatting Configuration Files
Ensure your Terraform files are properly formatted:
```bash
terraform fmt
```

## Validating Configuration
Check if your Terraform configuration is syntactically valid:
```bash
terraform validate
```

## Planning the Deployment
Generate an execution plan to preview changes:
```bash
terraform plan
```

## Applying the Configuration
Deploy the infrastructure to AWS:
```bash
terraform apply -auto-approve
```

## Destroying the Infrastructure
To remove all resources managed by Terraform:
```bash
terraform destroy -auto-approve
```

## Adding a .gitignore File
To prevent tracking unnecessary files, add the following to `.gitignore`:
```
.terraform/
*.tfstate
*.tfstate.backup
my_terraform_key
```
Then commit the `.gitignore` file:
```bash
git add .gitignore
git commit -m "Added .gitignore to exclude Terraform state files and SSH keys"
```

## Pushing to GitHub
Push the changes to GitHub:
```bash
git push origin main
```

## Troubleshooting
If you encounter an issue with large files:
```bash
git rm -r --cached .terraform
```
Commit and push again:
```bash
git commit -m "Removed .terraform from tracking"
git push origin main --force

