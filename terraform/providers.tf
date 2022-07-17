provider "aws" {
  region = "us-east-1"
  # access_key = "AKIAVTKQFJR5CGFPFIMU"
  # secret_key = "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"
  access_key = "AKIAVTKQFJR5BJBC25NZ"
  secret_key = "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"
  assume_role {
    role_arn  = "arn:aws:iam::385104563322:role/glue-job-role"
  }
  
}