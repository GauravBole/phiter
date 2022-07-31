
provider "aws" {
  region = "us-east-1"
  # access_key = "AKIAVTKQFJR5CGFPFIMU"
  # secret_key = "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"
  access_key = ""
  secret_key = ""
  # assume_role {
  #   role_arn  = "arn:aws:iam::385104563322:role/glue-job-role"
  #   }

}


terraform {
  backend "s3" {
    bucket = "phiter"
    key    = "terraform.tfstate"
    region = "us-east-1"
    access_key = ""
    secret_key = ""

  }
}
