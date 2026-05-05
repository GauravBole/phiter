resource "aws_iam_role" "stepfunctions_exec" {
  name = "${var.project_name}-sfn-exec-role-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "states.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy" "stepfunctions_policy" {
  name = "${var.project_name}-sfn-policy-${var.environment}"
  role = aws_iam_role.stepfunctions_exec.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = ["lambda:InvokeFunction"]
        Effect = "Allow"
        Resource = [
          aws_lambda_function.extract.arn,
          aws_lambda_function.transform.arn
        ]
      },
      {
        Action = ["glue:StartJobRun", "glue:GetJobRun", "glue:GetJobRuns", "glue:BatchStopJobRun"]
        Effect = "Allow"
        Resource = aws_glue_job.aggregate_job.arn
      }
    ]
  })
}

resource "aws_sfn_state_machine" "pipeline" {
  name     = "${var.project_name}-pipeline-${var.environment}"
  role_arn = aws_iam_role.stepfunctions_exec.arn

  definition = jsonencode({
    Comment = "Batch Data Pipeline Orchestration"
    StartAt = "ExtractData"
    States = {
      ExtractData = {
        Type = "Task"
        Resource = aws_lambda_function.extract.arn
        Next = "TransformData"
      }
      TransformData = {
        Type = "Task"
        Resource = aws_lambda_function.transform.arn
        Next = "AggregateData"
      }
      AggregateData = {
        Type = "Task"
        Resource = "arn:aws:states:::glue:startJobRun.sync"
        Parameters = {
          JobName = aws_glue_job.aggregate_job.name
        }
        End = true
      }
    }
  })
}
