resource "aws_sfn_state_machine" "user_onboarding_workflow" {
  name = "user_onboarding_workflow"
  definition = <<EOF
{
  "Comment": "User Onboarding Workflow",
  "StartAt": "ValidateUserData",
  "States": {
    "ValidateUserData": {
      "Type": "Task",
      "Resource": "${aws_lambda_function.pylambda1.arn}",
      "Next": "CheckUserType"
    },
    "CheckUserType": {
      "Type": "Choice",
      "Choices": [
        {
          "Variable": "$.user_data.user_type",
          "StringEquals": "premium",
          "Next": "PremiumUserTasks"
        }
      ],
      "Default": "CreateUserInCognito"
    },
    "PremiumUserTasks": {
      "Type": "Parallel",
      "Branches": [
        {
          "StartAt": "StorePremiumUserPreferencesInDynamoDB",
          "States": {
            "StorePremiumUserPreferencesInDynamoDB": {
              "Type": "Task",
              "Resource": "${aws_lambda_function.pylambda4.arn}",
              "End": true
            }
          }
        },
        {
          "StartAt": "CreateCognitoUser",
          "States": {
            "CreateCognitoUser": {
              "Type": "Task",
              "Resource": "${aws_lambda_function.pylambda2.arn}",
              "End": true
            }
          }
        }
      ],
      "Next": "SendWelcomeEmail"
    },
    "CreateUserInCognito": {
      "Type": "Task",
      "Resource": "${aws_lambda_function.pylambda2.arn}",
      "Next": "SendWelcomeEmail"
    },
    "SendWelcomeEmail": {
      "Type": "Task",
      "Resource": "${aws_lambda_function.pylambda3.arn}",
      "End": true
    }
  }
}
EOF
  role_arn = aws_iam_role.sfn_role.arn
}