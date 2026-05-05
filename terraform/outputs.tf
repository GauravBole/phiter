output "landing_bucket_name" {
  value       = aws_s3_bucket.landing.id
  description = "The name of the landing bucket"
}

output "staging_bucket_name" {
  value       = aws_s3_bucket.staging.id
  description = "The name of the staging bucket"
}

output "analytics_bucket_name" {
  value       = aws_s3_bucket.analytics.id
  description = "The name of the analytics bucket"
}
