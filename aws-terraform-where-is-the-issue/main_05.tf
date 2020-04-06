provider "aws" {
  region = "eu-west-1"
}

terraform {
  backend "s3" {
    key            = "global/s3/corporate/terraform.tfstate"
    bucket         = "mat-tf-state"
    region         = "eu-west-1"
    dynamodb_table = "mat-tf-state"
    encrypt        = true
    acl            = "private"
  }
}

locals {
  account-id   = "arn:aws:iam::${data.aws_caller_identity.current.account_id}"
  user_admin01 = "Admin01"
  user_admin02 = "Admin02"
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "this" {
  version = "2012-10-17"
  statement {
    sid    = "AllowListFoldercontent"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        "${local.account-id}:user/${local.user_admin01}",
        "${local.account-id}:user/${local.user_admin02}"
      ]
    }
    actions   = ["s3:ListBucket"]
    resources = ["${aws_s3_bucket.this.arn}"]
    condition {
      test     = "StringEquals"
      variable = "s3:prefix"
      values   = ["Backups/", "Backups/*"]
    }
  }
  statement {
    sid    = "AllowObjectOperations"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = ["*"]
    }
    actions = ["s3:*Object"]
    resources = [
      "${aws_s3_bucket.this.arn}/Backups/"
    ]
  }
}

resource "aws_s3_bucket" "this" {
  acl = "private"
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.this.json
}

output "arn" {
  description = "The ARN of the corporate bucket"
  value       = aws_s3_bucket.this.arn
}