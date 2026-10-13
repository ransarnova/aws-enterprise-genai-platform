variable "aws_region" {
  description = "AWS Region for Terraform backend resources."
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project name used for resource identification."
  type        = string
  default     = "enterprise-genai-platform"
}
