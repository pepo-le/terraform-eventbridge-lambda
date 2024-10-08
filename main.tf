module "iam_role_exec_lambda" {
  source    = "./modules/iam_role"
  role_name = "foo-dev-task-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
      },
    ],
  })
}

module "iam_role_policy_attachment_lambda" {
  source     = "./modules/iam_role_policy_attachment"
  role_name  = module.iam_role_exec_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

module "lambda" {
  source              = "./modules/lambda"
  function_name       = "foo-dev-function"
  archive_source_dir  = "./lambda_functions/source"
  archive_output_path = "./lambda_functions/archive/index.zip"
  exec_role_arn       = module.iam_role_exec_lambda.arn
  runtime             = "python3.12"
}

module "eventbridge_lambda" {
  source              = "./modules/eventbridge"
  event_name          = "foo-dev-event"
  event_description   = "foo-dev-event-description"
  target_id           = "eventbridge-lambda"
  schedule_expression = "cron(* * * * ? *)"
  target_arn          = module.lambda.arn
}

module "lambda_permission_eventbridge" {
  source               = "./modules/lambda_permission"
  policy_statement_id  = "AllowExecutionFromEventBridge"
  lambda_function_name = module.lambda.function_name
  principal            = "events.amazonaws.com"
  source_arn           = module.eventbridge_lambda.arn
}

module "iam_role_eventbridge_scheduler" {
  source    = "./modules/iam_role"
  role_name = "foo-dev-eventbridge-scheduler-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "scheduler.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

module "iam_policy_eventbridge_scheduler_lambda" {
  source             = "./modules/iam_policy"
  policy_name        = "eventbridge-shcedule-lambda-policy"
  policy_description = "eventbridge-schedule-lambda-policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "lambda:InvokeFunction"
        ],
        Effect   = "Allow",
        Resource = "arn:aws:lambda:*"
      }
    ]
  })
}

module "iam_role_policy_attachment_bastion_startstop" {
  source     = "./modules/iam_role_policy_attachment"
  role_name  = module.iam_role_eventbridge_scheduler.name
  policy_arn = module.iam_policy_eventbridge_scheduler_lambda.arn
}

module "eventbridge_scheduler_lambda" {
  source                       = "./modules/eventbridge_scheduler"
  schedule_name                = "foo-dev-event"
  group_name                   = "default"
  flexible_time_window_mode    = "OFF"
  schedule_expression          = "cron(* * * * ? *)"
  schedule_expression_timezone = "Asia/Tokyo"
  target_arn                   = module.lambda.arn
  role_arn                     = module.iam_role_eventbridge_scheduler.arn
}
