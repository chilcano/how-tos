provider "aws" {
  region  = "${var.region}"
  profile = "${var.profile}"
}

resource "aws_s3_bucket" "mat-public" {
  bucket = "${var.public-bucket-name}"
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "mat-public" {
  bucket                  = "${aws_s3_bucket.mat-public.id}"
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "mat-private" {
  bucket = "${var.private-bucket-name}"
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "mat-private" {
  bucket                  = "${aws_s3_bucket.mat-private.id}"
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "trustpolicy" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = [
      "sts:AssumeRole"
    ]
  }
}

resource "aws_iam_role" "buckets" {
  name               = "tf-buckets"
  assume_role_policy = "${data.aws_iam_policy_document.trustpolicy.json}"
}

data "aws_iam_policy_document" "buckets" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "s3:*"
    ]
    resources = [
      "${aws_s3_bucket.mat-public.arn}/*",
      "${aws_s3_bucket.mat-public.arn}",
      "${aws_s3_bucket.mat-private.arn}/*",
      "${aws_s3_bucket.mat-private.arn}"
    ]
  }
}

resource "aws_iam_policy" "buckets" {
  name   = "tf-buckets"
  policy = "${data.aws_iam_policy_document.buckets.json}"
}

resource "aws_iam_policy_attachment" "buckets" {
  name       = "tf-public-buckets"
  roles      = ["${aws_iam_role.buckets.name}"]
  policy_arn = "${aws_iam_policy.buckets.arn}"
}

resource "aws_iam_instance_profile" "buckets" {
  name  = "buckets"
  roles = ["${aws_iam_role.buckets.name}"]
}

resource "aws_instance" "access-public-buckets" {
  ami                  = "${var.image-id}"
  instance_type        = "${var.instance-type}"
  iam_instance_profile = "${aws_iam_instance_profile.buckets.name}"
  key_name             = "${var.key-name}"

  tags = {
    Name        = "access-public-buckets"
    Environment = "prod"
    BucketType  = "public"
  }
}

resource "aws_instance" "access-private-buckets" {
  ami                  = "${var.image-id}"
  instance_type        = "${var.instance-type}"
  iam_instance_profile = "${aws_iam_instance_profile.buckets.name}"
  key_name             = "${var.key-name}"

  tags = {
    Name        = "access-private-buckets"
    Environment = "prod"
    BucketType  = "private"
  }
}