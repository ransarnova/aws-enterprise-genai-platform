variable "name_prefix" {
  description = "Prefix used for naming EKS resources."
  type        = string
}

variable "enable_cluster" {
  description = "Whether to provision the EKS control plane."
  type        = bool
  default     = false
}

variable "cluster_name" {
  description = "Name of the EKS cluster."
  type        = string
}

variable "kubernetes_version" {
  description = "Supported Kubernetes version for the EKS cluster."
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for EKS cluster networking."
  type        = list(string)
}

variable "admin_trusted_role_arn" {
  description = "Existing IAM role allowed to assume the EKS administrator role."
  type        = string
}

variable "endpoint_public_access" {
  description = "Enable the public EKS Kubernetes API endpoint."
  type        = bool
  default     = false
}

variable "public_access_cidrs" {
  description = "CIDR blocks allowed to access the public Kubernetes API endpoint."
  type        = list(string)
  default     = []
}
