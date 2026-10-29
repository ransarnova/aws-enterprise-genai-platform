
resource "aws_api_gateway_integration" "health" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.health.id
  http_method = aws_api_gateway_method.health_get.http_method

  type                    = "HTTP_PROXY"
  integration_http_method = "GET"

  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.this.id
  integration_target = data.aws_lb.internal.arn

  uri = "http://${data.aws_lb.internal.dns_name}/api/v1/health"

  timeout_milliseconds = 29000
}

resource "aws_api_gateway_integration" "application_summary" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.application_summary.id
  http_method = aws_api_gateway_method.application_summary_post.http_method

  type                    = "HTTP_PROXY"
  integration_http_method = "POST"

  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.this.id
  integration_target = data.aws_lb.internal.arn

  uri = "http://${data.aws_lb.internal.dns_name}/api/v1/application-summary"

  timeout_milliseconds = 29000
}

resource "aws_api_gateway_integration" "policy_qa" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.policy_qa.id
  http_method = aws_api_gateway_method.policy_qa_post.http_method

  type                    = "HTTP_PROXY"
  integration_http_method = "POST"

  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.this.id
  integration_target = data.aws_lb.internal.arn

  uri = "http://${data.aws_lb.internal.dns_name}/api/v1/policy-qa"

  timeout_milliseconds = 29000
}
