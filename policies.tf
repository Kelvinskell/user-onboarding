# Bucket policy
resource "aws_s3_bucket_policy" "user_onboarding_bucket_policy" {
  bucket = aws_s3_bucket.user_onboarding_bucket.bucket

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = "*"
        Action = "s3:GetObject"
        Resource = "${aws_s3_bucket.user_onboarding_bucket.arn}/*"
      }
    ]
  })
}

# API gateway policy
resource "aws_iam_policy" "api_gateway_policy" {
  name        = "APIGatewayStepFunctionsPolicy"
  description = "Policy to allow API Gateway to start Step Functions execution"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "states:StartExecution",
      "Resource": "${aws_sfn_state_machine.user_onboarding_workflow.arn}"
    }
  ]
}
EOF
}

# Step Functions Policy
resource "aws_iam_policy" "stepfunctions_execution_policy" {
  name        = "StepFunctionsExecutionPolicy"
  description = "Policy for Step Functions to execute workflows"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "lambda:InvokeFunction",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      },
      {
        Effect   = "Allow",
        Action   = "states:*",
        Resource = "*"
      }
    ]
  })
}

# IAM policy for Lambda execution role (This policies don't follow least priviledge principle. Don't use in Prod)
resource "aws_iam_policy" "lambda_execution_policy" {
  name        = "LambdaExecutionPolicy"
  description = "Policy for Lambda execution role"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "dynamodb:PutItem",
        "cognito-idp:SignUp",
        "cognito-idp:AdminCreateUser",
        "cognito-idp:AdminSetUserPassword",
        "sns:Publish"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}