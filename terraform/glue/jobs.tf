
module "glue_etl_job" {
    source = "./modules/glue"
    
    aws_account_id = var.aws_account_id
    environmanet = var.environmanet
    job_name = format("phiter-test_%s", var.environmanet)
    code_bucket = var.code_bucket
    script_file = "first_glue_job.py"
    glue_role_arn = aws_iam_role.glue_service.arn

    default_arguments = {
        "--TempDir" = "s3://phiter-demo/temp/"
        "--account_id" = var.aws_account_id
        "--athena_database" = "gb"
        "s3_bucket" = var.code_bucket
    }

    
}