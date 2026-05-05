resource "aws_glue_catalog_database" "analytics_db" {
  name = "${var.project_name}_analytics_db_${var.environment}"
}

resource "aws_glue_job" "aggregate_job" {
  name     = "${var.project_name}-aggregate-job-${var.environment}"
  role_arn = aws_iam_role.glue_exec.arn

  command {
    script_location = "s3://${aws_s3_bucket.landing.id}/scripts/job.py"
    python_version  = "3"
  }

  default_arguments = {
    "--job-language" = "python"
    "--TempDir"      = "s3://${aws_s3_bucket.analytics.id}/temp/"
  }

  glue_version = "4.0"
  worker_type  = "G.1X"
  number_of_workers = 2
}

resource "aws_iam_role_policy" "glue_s3_access" {
  name = "${var.project_name}-glue-s3-${var.environment}"
  role = aws_iam_role.glue_exec.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Effect = "Allow"
        Resource = [
          aws_s3_bucket.staging.arn,
          "${aws_s3_bucket.staging.arn}/*",
          aws_s3_bucket.analytics.arn,
          "${aws_s3_bucket.analytics.arn}/*",
          aws_s3_bucket.landing.arn,
          "${aws_s3_bucket.landing.arn}/*"
        ]
      }
    ]
  })
}
