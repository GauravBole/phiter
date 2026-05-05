resource "aws_cloudwatch_event_rule" "daily_trigger" {
  name                = "${var.project_name}-daily-trigger-${var.environment}"
  description         = "Triggers the batch pipeline every day"
  schedule_expression = "cron(0 1 * * ? *)" # 1 AM UTC
}

resource "aws_cloudwatch_event_target" "step_functions_target" {
  rule      = aws_cloudwatch_event_rule.daily_trigger.name
  target_id = "StepFunctions"
  arn       = aws_sfn_state_machine.pipeline.arn
  role_arn  = aws_iam_role.eventbridge_exec.arn
}

resource "aws_iam_role" "eventbridge_exec" {
  name = "${var.project_name}-eb-exec-role-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "events.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy" "eventbridge_sfn_policy" {
  name = "${var.project_name}-eb-sfn-policy-${var.environment}"
  role = aws_iam_role.eventbridge_exec.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = ["states:StartExecution"]
        Effect = "Allow"
        Resource = aws_sfn_state_machine.pipeline.arn
      }
    ]
  })
}
