
variable "name_prefix" {
  description = "Resource naming prefix."
  type        = string
}

variable "vpc_id" {
  description = "VPC containing the private integration."
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR for initial VPC Link egress."
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for the VPC Link."
  type        = list(string)
}
variable "nlb_name" {
  description = "Name of the existing Kubernetes-managed internal NLB."
  type        = string
}

variable "cognito_user_pool_arn" {
  description = "ARN of the Cognito User Pool used to authorize API requests."
  type        = string
}
