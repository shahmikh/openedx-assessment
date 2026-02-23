# Multi-Environment Setup

We provide separate Terraform environments for dev, staging, and prod under infra/terraform/envs.

Each environment has:
- its own state backend (S3 + DynamoDB)
- distinct VPC and EKS cluster naming
- isolated data services

