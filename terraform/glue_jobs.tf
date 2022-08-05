module "glue_etl_job" {
    source = "./modules/glue"
    
    aws_account_id = var.aws_account_id
    environmanet = var.environmanet
    job_name = format("phiter-test_%s", var.environmanet)
    code_bucket = var.code_bucket
    script_file = "first_glue_job.py" #file should be in project scripts folder
    glue_role_arn = aws_iam_role.glue_service.arn

    default_arguments = {
        "--TempDir" = format("s3://%s/temp_dir/", var.code_bucket)
        "--account_id" = var.aws_account_id
        "--athena_database" = var.athena_database
        "--code_bucket" = var.code_bucket
        "--source_path" = format("s3://%s/source/", var.code_bucket)
        "--additional-python-modules" = "pydantic"
        "--extra-py-files" = format("s3://%s/packages/botobeak.zip", var.code_bucket)
    }
}