# Terraform Testing Learning Project

This repository demonstrates Terraform testing capabilities as a learning exercise.

## What's Inside

- **S3 Static Website** - Simple Terraform configuration creating an S3 bucket configured for static website hosting
- **Terraform Tests** - Test files in `tests/` directory that:
  - Validate S3 website URL format matches AWS pattern
  - Verify deployed website content returns "Hello World!"
- **GitHub Actions CI/CD** - Automated deployment using OIDC authentication with AWS

## Key Learning Areas

- Terraform test framework (`terraform test`)
- OIDC authentication for secure, keyless AWS deployments
- S3 remote state backend configuration
- GitHub Actions workflow automation

## Setup

1. Deploy `github-oidc-setup.yml` CloudFormation template
2. Configure GitHub secrets: `AWS_ROLE_ARN`, `TF_STATE_BUCKET`, `TF_STATE_KEY`, `AWS_REGION`
3. Push changes to trigger automated deployment

This is a sandbox project for exploring Terraform testing patterns and CI/CD best practices.