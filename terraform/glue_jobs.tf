module "glue_etl_job" {
    source = "./modules/glue"
    
    aws_account_id = var.aws_account_id
    environmanet = var.environmanet
    job_name = format("phiterw-test_%s", var.environmanet)
    code_bucket = var.code_bucket
    script_file = "."
    glue_role_arn = aws_iam_role.glue_service.arn

    default_arguments = {
        "--TempDir" = local.temp_dir
        "--account_id" = var.aws_account_id
        "--athena_database" = var.athena_database
        "s3_bucket" = var.code_bucket
    }
}