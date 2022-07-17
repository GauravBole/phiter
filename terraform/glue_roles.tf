data "aws_iam_policy_document" "glue_assume_role" {

  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["glue.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "glue_policy" {

  statement {
    sid = "GlueS3RadAction"
    actions = [
      "s3:Get*",
      "s3:list*",
    ]
    resources = ["*"] # Todo
  }

  statement {
    sid = "GlueS3objectActions"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
    ]
    resources = ["*"] # Todo
  }

  statement {
    sid = "GlueKMSActions"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:GenrateDataKey",
    ]
    resources = ["*"] # Todo
  }

}

output "role_value" {
  value = data.aws_iam_policy_document.glue_assume_role.json
}

resource "aws_iam_role" "glue_service" {
  name               = format("Glue_%s_policy", var.project_name)
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.glue_assume_role.json

  inline_policy {
    name   = "GlueServicePolicy"
    policy = data.aws_iam_policy_document.glue_policy.json
  }
}


resource "aws_iam_role_policy_attachment" "managed_policy" {
  role       = aws_iam_role.glue_service.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"

}
