terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
  backend "s3" {
  }
}

provider "aws" {
  region = "us-east-2"
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "website_bucket" {
  bucket = "my-terraform-website-${random_id.bucket_suffix.hex}"

  tags = {
    Name        = "Website Bucket"
    Environment = "dev"
    Project     = "terraform-testing"
  }
}

resource "aws_s3_bucket_versioning" "website_bucket_versioning" {
  bucket = aws_s3_bucket.website_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "website_bucket_public_access" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls       = false # Allow public ACLs
  block_public_policy     = false # Allow public bucket policies
  ignore_public_acls      = false # Don't ignore public ACLs
  restrict_public_buckets = false # Allow public bucket access
}

resource "aws_s3_bucket_policy" "website_bucket_policy" {
  bucket     = aws_s3_bucket.website_bucket.id
  depends_on = [aws_s3_bucket_public_access_block.website_bucket_public_access]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.website_bucket.arn}/*"
      }
    ]
  })
}

resource "aws_s3_object" "website_index" {
  bucket       = aws_s3_bucket.website_bucket.id
  key          = "index.html"
  content      = "<h1>Hello World!</h1>"
  content_type = "text/html"

  tags = {
    Name        = "Website Index"
    Environment = "dev"
    Project     = "terraform-testing"
  }
}

resource "aws_s3_bucket_website_configuration" "website_bucket_config" {
  bucket = aws_s3_bucket.website_bucket.id
  index_document {
    suffix = "index.html"
  }
}

output "website_url" {
  value = "http://${aws_s3_bucket_website_configuration.website_bucket_config.website_endpoint}"
}

data "http" "website_check" {
  url        = "http://${aws_s3_bucket_website_configuration.website_bucket_config.website_endpoint}"
  depends_on = [aws_s3_object.website_index]
}
