
data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "policy_documents" {
  bucket        = "${var.name_prefix}-${data.aws_caller_identity.current.account_id}-kb-documents"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "policy_documents" {
  bucket = aws_s3_bucket.policy_documents.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "policy_documents" {
  bucket = aws_s3_bucket.policy_documents.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# No aws_s3_bucket_versioning resource required.

resource "aws_s3_object" "lending_policy" {
  bucket       = aws_s3_bucket.policy_documents.id
  key          = "policies/lending-policy.txt"
  source       = var.policy_document_path
  etag         = filemd5(var.policy_document_path)
  content_type = "text/plain"

  server_side_encryption = "AES256"

  depends_on = [
    aws_s3_bucket_public_access_block.policy_documents,
    aws_s3_bucket_server_side_encryption_configuration.policy_documents
  ]
}
