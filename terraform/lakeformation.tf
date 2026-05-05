# Lake Formation Data Lake Settings
resource "aws_lakeformation_data_lake_settings" "main" {
  admins = [data.aws_caller_identity.current.arn]
}

# Register Analytics S3 bucket with Lake Formation
resource "aws_lakeformation_resource" "analytics_bucket" {
  arn = aws_s3_bucket.analytics.arn
}

# Grant permissions to PII Reader (Full access)
resource "aws_lakeformation_permissions" "pii_reader_db" {
  principal   = aws_iam_role.pii_reader.arn
  permissions = ["DESCRIBE"]

  database {
    name = aws_glue_catalog_database.analytics_db.name
  }
}

resource "aws_lakeformation_permissions" "pii_reader_table" {
  principal   = aws_iam_role.pii_reader.arn
  permissions = ["SELECT"]

  table {
    database_name = aws_glue_catalog_database.analytics_db.name
    name          = "analytics_data" # Target table that will be created
  }
}

# Grant permissions to Non-PII Reader (Column-level exclusion)
resource "aws_lakeformation_permissions" "non_pii_reader_db" {
  principal   = aws_iam_role.non_pii_reader.arn
  permissions = ["DESCRIBE"]

  database {
    name = aws_glue_catalog_database.analytics_db.name
  }
}

# Exclude PII columns for the Non-PII Reader
resource "aws_lakeformation_permissions" "non_pii_reader_table_columns" {
  principal   = aws_iam_role.non_pii_reader.arn
  permissions = ["SELECT"]

  table_with_columns {
    database_name = aws_glue_catalog_database.analytics_db.name
    name          = "analytics_data"
    excluded_column_names = ["email", "phone_number"] # PII columns to mask/drop
  }
}
