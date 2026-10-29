
variable "name_prefix" {
  description = "Prefix for application IAM resources."
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name."
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace for the application."
  type        = string
}

variable "service_account" {
  description = "Kubernetes ServiceAccount used by the application."
  type        = string
}

variable "bedrock_resource_arns" {
  description = "Allowed Bedrock model and inference profile resource ARNs."
  type        = list(string)

  validation {
    condition = (
      length(var.bedrock_resource_arns) > 0 &&
      alltrue([
        for arn in var.bedrock_resource_arns :
        startswith(arn, "arn:aws:bedrock:") && !strcontains(arn, "*")
      ])
    )
    error_message = "Provide explicit Bedrock resource ARNs without wildcards."
  }
}

variable "knowledge_base_arn" {
  description = "ARN of the Bedrock Knowledge Base accessible to the application"
  type        = string
}
