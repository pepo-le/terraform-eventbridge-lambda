# IAMロールの作成
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
  source               = "./modules/eventbridge-lambda"
  event_name           = "foo-dev-event"
  event_description    = "foo-dev-event-description"
  schedule_expression  = "cron(* * * * ? *)"
  lambda_arn           = module.lambda.arn
  lambda_function_name = module.lambda.function_name
  policy_statement_id  = "AllowExecutionFromEventBridge"
}
