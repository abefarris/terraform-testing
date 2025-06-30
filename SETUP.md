# GitHub Actions OIDC Setup for Terraform

## Prerequisites
- AWS CLI configured with admin permissions
- GitHub repository with Actions enabled

## Setup Steps

### 1. Deploy CloudFormation Stack
```bash
aws cloudformation create-stack \
  --stack-name terraform-github-oidc \
  --template-body file://github-oidc-setup.yml \
  --parameters ParameterKey=GitHubRepository,ParameterValue=YOUR_USERNAME/terraform-testing \
               ParameterKey=GitHubBranch,ParameterValue=main \
  --capabilities CAPABILITY_NAMED_IAM
```

### 2. Get Stack Outputs
```bash
aws cloudformation describe-stacks \
  --stack-name terraform-github-oidc \
  --query 'Stacks[0].Outputs'
```

### 3. Configure GitHub Secrets
In your GitHub repository settings, add these secrets:

- `AWS_ROLE_ARN`: The RoleArn output from CloudFormation
- `TF_STATE_BUCKET`: The S3BucketName output from CloudFormation  

### 4. Update Repository Parameter
Edit `github-oidc-setup.yml` line 9 to match your GitHub repository:
```yaml
Default: 'your-username/terraform-testing'
```

## What This Creates

1. **OIDC Identity Provider** - Allows GitHub Actions to authenticate with AWS
2. **IAM Role** - Grants necessary permissions for Terraform operations
3. **S3 Bucket** - Stores Terraform state files with versioning and encryption

## Security Features

- Role can only be assumed by your specific GitHub repository and branch
- S3 bucket has encryption and public access blocked
- PowerUserAccess policy (excludes most IAM operations)

## Testing

Push a change to trigger the workflow and verify:
1. Authentication works without AWS credentials
2. Terraform state is stored in S3