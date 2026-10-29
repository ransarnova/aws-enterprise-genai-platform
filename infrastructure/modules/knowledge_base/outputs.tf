
output "vector_index_arn" {
  description = "ARN of the lending policy vector index."
  value       = aws_s3vectors_index.lending_policy_index.index_arn
}

output "knowledge_base_id" {
  value = aws_bedrockagent_knowledge_base.lending_policy.id
}

output "data_source_id" {
  value = aws_bedrockagent_data_source.lending_policy.data_source_id
}

output "document_bucket_name" {
  value = aws_s3_bucket.policy_documents.id
}

output "knowledge_base_arn" {
  description = "ARN of the Bedrock Knowledge Base"
  value       = aws_bedrockagent_knowledge_base.lending_policy.arn
}
