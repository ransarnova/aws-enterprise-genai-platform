variable "aws_region" {
  description = "AWS Region in which the platform infrastructure is deployed."
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Name used to identify resources belonging to this platform."
  type        = string
  default     = "enterprise-genai-platform"
}

variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "lab"

  validation {
    condition     = contains(["lab", "dev", "test", "prod"], var.environment)
    error_message = "Environment must be one of: lab, dev, test, prod."
  }
}

variable "vpc_cidr" {
  description = "CIDR block assigned to the lab VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks assigned to the two public subnets."
  type        = list(string)

  default = [
    "10.0.0.0/24",
    "10.0.1.0/24",
  ]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks assigned to the two private subnets."
  type        = list(string)

  default = [
    "10.0.10.0/24",
    "10.0.11.0/24",
  ]
}
