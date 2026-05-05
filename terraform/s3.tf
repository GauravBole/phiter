resource "aws_s3_bucket" "landing" {
  bucket        = "${var.project_name}-landing-${var.environment}"
  force_destroy = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "landing_sse" {
  bucket = aws_s3_bucket.landing.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket" "staging" {
  bucket        = "${var.project_name}-staging-${var.environment}"
  force_destroy = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "staging_sse" {
  bucket = aws_s3_bucket.staging.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket" "analytics" {
  bucket        = "${var.project_name}-analytics-${var.environment}"
  force_destroy = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "analytics_sse" {
  bucket = aws_s3_bucket.analytics.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
