provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = "ap-south-1"
}

resource "aws_s3_bucket" "patientportal" {
  bucket = "patientportal-gl"
  acl    = "private"

  tags = {
    Name = "GL-Capstone"
  }
}

resource "aws_s3_bucket" "patientassessmentportal" {
  bucket = "patientassementportal-gl"
  acl    = "private"

  tags = {
    Name = "GL-Capstone"
  }
}

locals {
  s3_origin_id = "myS3Origin"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.patientportal.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = "origin-access-identity/cloudfront/XYZ"
    }
  }

  enabled = true

    default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["IN"]
    }
  }

  tags = {
    Environment = "production"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
