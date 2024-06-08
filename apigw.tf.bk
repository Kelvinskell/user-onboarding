# Create API GW
resource "aws_api_gateway_rest_api" "api" {
  name        = "UserOnboardingAPI"
  description = "API Gateway for triggering the user onboarding workflow"
}

# Create API Resource
resource "aws_api_gateway_resource" "user_onboarding" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "user_onboarding"
}

resource "aws_api_gateway_method" "post_method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.user_onboarding.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "step_function_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.user_onboarding.id
  http_method             = aws_api_gateway_method.post_method.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:us-east-1:states:action/StartExecution"
  credentials             = aws_iam_role.api_gateway_role.arn

  request_templates = {
    "application/json" = <<EOF
{
  "input": "$util.escapeJavaScript($input.json('$'))",
  "stateMachineArn": "${aws_sfn_state_machine.user_onboarding_workflow.arn}"
}
EOF
  }
}


resource "aws_api_gateway_method_response" "method_response" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.user_onboarding.id
  http_method = aws_api_gateway_method.post_method.http_method
  status_code = "200"
}


resource "aws_api_gateway_integration_response" "integration_response" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.user_onboarding.id
  http_method = aws_api_gateway_method.post_method.http_method
  status_code = aws_api_gateway_method_response.method_response.status_code

  depends_on = [ aws_api_gateway_integration.step_function_integration ]
}

# Deploy API
resource "aws_api_gateway_deployment" "apigw_deploy" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = "dev"

  depends_on = [
    aws_api_gateway_integration.step_function_integration
  ]
}

output "api_url" {
  description = "The url of the api gateway"
  value = aws_api_gateway_deployment.apigw_deploy.invoke_url
}