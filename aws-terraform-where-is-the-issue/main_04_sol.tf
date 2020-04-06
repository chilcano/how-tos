/*
Two different IAM policies have been defined with aws_iam_policy_document and then created with aws_iam_policy. 
These policies are attached to different IAM roles with aws_iam_policy_attachment. Each different role is used 
to create an instance profile for each EC2 instance.
*/

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

resource "aws_iam_role" "public-buckets" {
  name               = "tf-public-buckets"
  assume_role_policy = "${data.aws_iam_policy_document.trustpolicy.json}"
}

resource "aws_iam_role" "private-buckets" {
  name               = "tf-private-buckets"
  assume_role_policy = "${data.aws_iam_policy_document.trustpolicy.json}"
}

data "aws_iam_policy_document" "public-buckets" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "s3:Get*",
      "s3:List*"
    ]
    resources = [
      "${aws_s3_bucket.mat-public.arn}/*",
      "${aws_s3_bucket.mat-public.arn}"
    ]
  }
}

resource "aws_iam_policy" "public-buckets" {
  name   = "tf-public-buckets"
  policy = "${data.aws_iam_policy_document.public-buckets.json}"
}

resource "aws_iam_policy_attachment" "public-buckets" {
  name       = "tf-public-buckets"
  roles      = ["${aws_iam_role.public-buckets.name}"]
  policy_arn = "${aws_iam_policy.public-buckets.arn}"
}

data "aws_iam_policy_document" "private-buckets" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "s3:*Object"
    ]
    resources = [
      "${aws_s3_bucket.mat-private.arn}/*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket"
    ]
    resources = [
      "${aws_s3_bucket.mat-private.arn}"
    ]
  }
}

resource "aws_iam_policy" "private-buckets" {
  name   = "tf-private-buckets"
  policy = "${data.aws_iam_policy_document.private-buckets.json}"
}

resource "aws_iam_policy_attachment" "private-buckets" {
  name       = "tf-access-policy-private-buckets"
  roles      = ["${aws_iam_role.private-buckets.name}"]
  policy_arn = "${aws_iam_policy.private-buckets.arn}"
}

resource "aws_iam_instance_profile" "public-buckets" {
  name  = "public-buckets"
  roles = ["${aws_iam_role.public-buckets.name}"]
}

resource "aws_instance" "access-public-buckets" {
  ami                  = "${var.image-id}"
  instance_type        = "${var.instance-type}"
  iam_instance_profile = "${aws_iam_instance_profile.public-buckets.name}"
  key_name             = "${var.key-name}"

  tags = {
    Name        = "access-public-buckets"
    Environment = "prod"
    BucketType  = "public"
  }
}

resource "aws_iam_instance_profile" "private-buckets" {
  name  = "private-buckets"
  roles = ["${aws_iam_role.private-buckets.name}"]
}

resource "aws_instance" "access-private-buckets" {
  ami                  = "${var.image-id}"
  instance_type        = "${var.instance-type}"
  iam_instance_profile = "${aws_iam_instance_profile.private-buckets.name}"
  key_name             = "${var.key-name}"

  tags = {
    Name        = "access-private-buckets"
    Environment = "prod"
    BucketType  = "private"
  }
}