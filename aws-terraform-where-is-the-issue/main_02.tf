locals {
  s3_origin_id = "s3-content-bucket"
}

data "aws_iam_policy_document" "cdn-content" {
  version = "2012-10-17"
  statement {
    sid     = "AllowCloudFrontOAI"
    effect  = "Allow"
    actions = ["s3:*"]
    principals {
      type = "CanonicalUser"
      identifiers = [
        aws_cloudfront_origin_access_identity.oai.s3_canonical_user_id
      ]
    }
    resources = ["${aws_s3_bucket.cdn-content.arn}/*"]
  }
}

resource "aws_s3_bucket_policy" "cdn-content" {
  bucket = aws_s3_bucket.cdn-content.id
  policy = data.aws_iam_policy_document.cdn-content.json
}

resource "aws_s3_bucket_public_access_block" "cdn-content" {
  bucket                  = aws_s3_bucket.cdn-content.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "cdn-content" {
  acl = "private"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  tags = {
    Name        = var.name
    Environment = var.environment
  }
}

resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "CloudFront OAI for S3 content delivery"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  enabled             = true
  price_class         = "PriceClass_100"
  default_root_object = "index.html"
  http_version        = "http2"
  origin {
    domain_name = aws_s3_bucket.cdn-content.bucket_regional_domain_name
    origin_id   = local.s3_origin_id
    s3_origin_config {
      origin_access_identity = join("",
        ["origin-access-identity/cloudfront/",
        "${aws_cloudfront_origin_access_identity.oai.id}"]
      )
    }
  }
  custom_error_response {
    error_caching_min_ttl = 300
    error_code            = 403
    response_code         = 404
    response_page_path    = "/404.html"
  }
  default_cache_behavior {
    target_origin_id = "${local.s3_origin_id}"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
    viewer_protocol_policy = "https-only"
  }
  viewer_certificate {
    cloudfront_default_certificate = true
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Name        = var.name
    Environment = var.environment
  }
}