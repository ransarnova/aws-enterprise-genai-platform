
resource "aws_s3vectors_vector_bucket" "lending_policy_bucket" {
  vector_bucket_name = "${var.name_prefix}-vectors"
  force_destroy      = true
}

resource "aws_s3vectors_index" "lending_policy_index" {
  index_name         = "lending-policy-index"
  vector_bucket_name = aws_s3vectors_vector_bucket.lending_policy_bucket.vector_bucket_name

  data_type       = "float32"
  dimension       = 256
  distance_metric = "cosine"

  metadata_configuration {
    non_filterable_metadata_keys = [
      "AMAZON_BEDROCK_TEXT",
      "AMAZON_BEDROCK_METADATA"
    ]
  }
}
