resource "aws_athena_workgroup" "analytics" {
  name = "${var.project_name}_analytics_${var.environment}"

  configuration {
    enforce_workgroup_configuration    = true
    publish_cloudwatch_metrics_enabled = true

    result_configuration {
      output_location = "s3://${aws_s3_bucket.analytics.id}/athena-results/"
    }
  }
}
