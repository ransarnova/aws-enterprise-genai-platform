
resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id

  triggers = {
    redeployment = sha1(jsonencode({
      authorizer = {
        id            = aws_api_gateway_authorizer.cognito.id
        type          = aws_api_gateway_authorizer.cognito.type
        provider_arns = aws_api_gateway_authorizer.cognito.provider_arns
      }

      health = {
        resource_id    = aws_api_gateway_resource.health.id
        method_id      = aws_api_gateway_method.health_get.id
        authorization  = aws_api_gateway_method.health_get.authorization
        integration_id = aws_api_gateway_integration.health.id
        uri            = aws_api_gateway_integration.health.uri
      }

      application_summary = {
        resource_id          = aws_api_gateway_resource.application_summary.id
        method_id            = aws_api_gateway_method.application_summary_post.id
        authorization        = aws_api_gateway_method.application_summary_post.authorization
        authorizer_id        = aws_api_gateway_method.application_summary_post.authorizer_id
        authorization_scopes = aws_api_gateway_method.application_summary_post.authorization_scopes
        integration_id       = aws_api_gateway_integration.application_summary.id
        uri                  = aws_api_gateway_integration.application_summary.uri
      }

      policy_qa = {
        resource_id          = aws_api_gateway_resource.policy_qa.id
        method_id            = aws_api_gateway_method.policy_qa_post.id
        authorization        = aws_api_gateway_method.policy_qa_post.authorization
        authorizer_id        = aws_api_gateway_method.policy_qa_post.authorizer_id
        authorization_scopes = aws_api_gateway_method.policy_qa_post.authorization_scopes
        integration_id       = aws_api_gateway_integration.policy_qa.id
        uri                  = aws_api_gateway_integration.policy_qa.uri
      }
    }))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "lab" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  deployment_id = aws_api_gateway_deployment.this.id
  stage_name    = "lab"

  tags = {
    Name = "${var.name_prefix}-stage"
  }
}

resource "aws_api_gateway_method_settings" "lab" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  stage_name  = aws_api_gateway_stage.lab.stage_name
  method_path = "*/*"

  settings {
    throttling_rate_limit  = 5
    throttling_burst_limit = 10
  }
}
