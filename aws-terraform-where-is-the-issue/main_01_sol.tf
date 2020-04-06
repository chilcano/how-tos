/*
   ---
*/

provider "aws" {
  region  = "${var.main-region}"
  profile = "${var.profile}"
}

provider "aws" {
  alias   = "replica"
  region  = "${var.replica-region}"
  profile = "${var.profile}"
}

resource "aws_s3_bucket" "matoriginal" {
  bucket = "${var.main-bucket-name}"
  acl    = "private"

  versioning {
    enabled = true
  }

  replication_configuration {
    role = "${aws_iam_role.replication.arn}"

    rules {
      id     = "rule1"
      status = "Enabled"

      destination {
        bucket        = "${aws_s3_bucket.matreplica.arn}"
        storage_class = "STANDARD"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "matoriginal" {
  bucket                  = "${aws_s3_bucket.matoriginal.id}"
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "matreplica" {
  provider = "aws.replica"
  bucket   = "${var.replica-bucket-name}"
  acl      = "private"
  region   = "${var.replica-region}"

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "matreplica" {
  provider                = "aws.replica"
  bucket                  = "${aws_s3_bucket.matreplica.id}"
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
      identifiers = ["s3.amazonaws.com"]
    }
    actions = [
      "sts:AssumeRole"
    ]
  }
}

resource "aws_iam_role" "replication" {
  name               = "tf-iam-role-mat-bucket-replication"
  assume_role_policy = "${data.aws_iam_policy_document.trustpolicy.json}"
}

data "aws_iam_policy_document" "replicationrolepolicy" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "s3:GetReplicationConfiguration",
      "s3:ListBucket"
    ]
    resources = [
      "${aws_s3_bucket.matoriginal.arn}"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObjectVersion",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionTagging",
      "s3:GetObjectRetention",
      "s3:GetObjectLegalHold"
    ]
    resources = [
      "${aws_s3_bucket.matoriginal.arn}/*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
      "s3:ReplicateTags"
    ]
    resources = [
      "${aws_s3_bucket.matreplica.arn}/*"
    ]
  }
}

resource "aws_iam_policy" "replication" {
  name   = "tf-iam-role-policy-mat-bucket-replication"
  policy = "${data.aws_iam_policy_document.replicationrolepolicy.json}"
}

resource "aws_iam_policy_attachment" "replication" {
  name       = "tf-iam-role-attachment-matreplication"
  roles      = ["${aws_iam_role.replication.name}"]
  policy_arn = "${aws_iam_policy.replication.arn}"
}