data "archive_file" "extract_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../src/lambda_extract"
  output_path = "${path.module}/lambda_extract.zip"
}

resource "aws_lambda_function" "extract" {
  filename         = data.archive_file.extract_zip.output_path
  function_name    = "${var.project_name}-extract-${var.environment}"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "app.lambda_handler"
  runtime          = "python3.9"
  source_code_hash = data.archive_file.extract_zip.output_base64sha256

  environment {
    variables = {
      LANDING_BUCKET = aws_s3_bucket.landing.id
    }
  }
}

data "archive_file" "transform_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../src/lambda_transform"
  output_path = "${path.module}/lambda_transform.zip"
}

resource "aws_lambda_function" "transform" {
  filename         = data.archive_file.transform_zip.output_path
  function_name    = "${var.project_name}-transform-${var.environment}"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "app.lambda_handler"
  runtime          = "python3.9"
  source_code_hash = data.archive_file.transform_zip.output_base64sha256

  environment {
    variables = {
      LANDING_BUCKET = aws_s3_bucket.landing.id
      STAGING_BUCKET = aws_s3_bucket.staging.id
    }
  }
}

resource "aws_iam_role_policy" "lambda_s3_access" {
  name = "${var.project_name}-lambda-s3-${var.environment}"
  role = aws_iam_role.lambda_exec.id

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
          aws_s3_bucket.landing.arn,
          "${aws_s3_bucket.landing.arn}/*",
          aws_s3_bucket.staging.arn,
          "${aws_s3_bucket.staging.arn}/*"
        ]
      }
    ]
  })
}
