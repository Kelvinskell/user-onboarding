data "archive_file" "lambda1" {
  type        = "zip"
  source_file = "src/validate_user_data.py"
  output_path = "validate_user_data.py.zip"
}
data "archive_file" "lambda2" {
  type        = "zip"
  source_file = "src/create_cognito_user.py"
  output_path = "create_cognito_user.py.zip"
}
data "archive_file" "lambda3" {
  type        = "zip"
  source_file = "src/send_welcome_email.py"
  output_path = "send_welcome_email.py.zip"
}
data "archive_file" "lambda4" {
  type        = "zip"
  source_file = "src/store_premium_users.py"
  output_path = "store_premium_users.py.zip"
}
data "archive_file" "lambda5" {
  type        = "zip"
  source_file = "src/setup_user_preferences.py"
  output_path = "setup_user_preferences.py.zip"
}

resource "aws_lambda_function" "pylambda1" {
  filename         = "validate_user_data.py.zip"
  function_name    = "validate_user_data"
  role             = aws_iam_role.lambda_execution_role.arn
  source_code_hash = data.archive_file.lambda1.output_base64sha256
  runtime          = "python3.12"
  handler          = "validate_user_data.lambda_handler"
}
resource "aws_lambda_function" "pylambda2" {
  filename         = "create_cognito_user.py.zip"
  function_name    = "create_cognito_user"
  role             = aws_iam_role.lambda_execution_role.arn
  source_code_hash = data.archive_file.lambda2.output_base64sha256
  runtime          = "python3.12"
  handler          = "create_cognito_user.lambda_handler"

  environment {
    variables = {
      USER_POOL_ID = aws_cognito_user_pool.user_pool.id
    }
}
}

resource "aws_lambda_function" "pylambda3" {
  filename         = "send_welcome_email.py.zip"
  function_name    = "send_welcome_email"
  role             = aws_iam_role.lambda_execution_role.arn
  source_code_hash = data.archive_file.lambda3.output_base64sha256
  runtime          = "python3.12"
  handler          = "send_welcome_email.lambda_handler"

  environment {
    variables = {
      TOPIC_ARN = aws_sns_topic.topic.arn
    }
  }
}
resource "aws_lambda_function" "pylambda4" {
  filename         = "store_premium_users.py.zip"
  function_name    = "store_premium_users"
  role             = aws_iam_role.lambda_execution_role.arn
  source_code_hash = data.archive_file.lambda4.output_base64sha256
  runtime          = "python3.12"
  handler          = "store_premium_users.lambda_handler"
}
resource "aws_lambda_function" "pylambda5" {
  filename         = "setup_user_preferences.py.zip"
  function_name    = "setup_user_preferences"
  role             = aws_iam_role.lambda_execution_role.arn
  source_code_hash = data.archive_file.lambda5.output_base64sha256
  runtime          = "python3.12"
  handler          = "setup_user_preferences.lambda_handler"
}