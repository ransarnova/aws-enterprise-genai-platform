output "user_pool_id" {
  value = aws_cognito_user_pool.this.id
}

output "user_pool_arn" {
  value = aws_cognito_user_pool.this.arn
}

output "machine_client_id" {
  value = aws_cognito_user_pool_client.machine.id
}

output "token_endpoint" {
  value = "https://${aws_cognito_user_pool_domain.this.domain}.auth.${data.aws_region.current.region}.amazoncognito.com/oauth2/token"
}

output "frontend_client_id" {
  description = "Cognito public frontend application client ID"
  value       = aws_cognito_user_pool_client.frontend.id
}
