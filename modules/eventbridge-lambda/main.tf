resource "aws_cloudwatch_event_rule" "main" {
  name                = var.event_name
  description         = var.event_description
  schedule_expression = var.schedule_expression
}

resource "aws_cloudwatch_event_target" "main" {
  rule      = aws_cloudwatch_event_rule.main.name
  target_id = "lambda"
  arn       = var.lambda_arn

  retry_policy {
    maximum_retry_attempts       = var.retry_attempts
    maximum_event_age_in_seconds = var.event_age
  }
}

# Lambda関数の実行許可
resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = var.policy_statement_id
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.main.arn
}
