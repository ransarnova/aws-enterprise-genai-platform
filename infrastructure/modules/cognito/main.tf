data "aws_region" "current" {}

resource "aws_cognito_user_pool" "this" {
  name = "${var.name_prefix}-user-pool"

  deletion_protection = "INACTIVE"

  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]

  admin_create_user_config {
    allow_admin_create_user_only = true
  }

  password_policy {
    minimum_length    = 12
    require_lowercase = true
    require_uppercase = true
    require_numbers   = true
    require_symbols   = true
  }

  tags = {
    Name = "${var.name_prefix}-user-pool"
  }
}

resource "aws_cognito_resource_server" "genai" {
  identifier   = "genai"
  name         = "${var.name_prefix}-resource-server"
  user_pool_id = aws_cognito_user_pool.this.id

  scope {
    scope_name        = "application-summary"
    scope_description = "Invoke the application summary API"
  }

  scope {
    scope_name        = "policy-qa"
    scope_description = "Invoke the policy Q&A API"
  }
}

resource "aws_cognito_user_pool_client" "machine" {
  name         = "${var.name_prefix}-machine-client"
  user_pool_id = aws_cognito_user_pool.this.id

  generate_secret = true

  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["client_credentials"]

  allowed_oauth_scopes = [
    "genai/application-summary",
    "genai/policy-qa"
  ]

  supported_identity_providers = ["COGNITO"]

  depends_on = [
    aws_cognito_resource_server.genai
  ]
}

resource "aws_cognito_user_pool_domain" "this" {
  domain                = "${var.name_prefix}-auth"
  user_pool_id          = aws_cognito_user_pool.this.id
  managed_login_version = 2
}

resource "aws_cognito_managed_login_branding" "frontend" {
  user_pool_id = aws_cognito_user_pool.this.id
  client_id    = aws_cognito_user_pool_client.frontend.id

  use_cognito_provided_values = true
}

resource "aws_cognito_user_pool_client" "frontend" {
  name         = "${var.name_prefix}-frontend-client"
  user_pool_id = aws_cognito_user_pool.this.id

  generate_secret = false

  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code"]

  allowed_oauth_scopes = [
    "openid",
    "email",
    "genai/application-summary",
    "genai/policy-qa"
  ]

  callback_urls = [
    "http://localhost:3000/auth/callback"
  ]

  logout_urls = [
    "http://localhost:3000/"
  ]

  supported_identity_providers = ["COGNITO"]

  enable_token_revocation = true

  depends_on = [
    aws_cognito_resource_server.genai
  ]
}
