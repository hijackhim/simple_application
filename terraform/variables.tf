variable "project_name" {
  type        = string
  description = "Project name for EKS cluster"
  default     = "pythonapp"
}

variable "region" {
  type        = string
  description = "AWS region"
  default     = "ap-south-1"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  type        = list(string)
  description = "Public subnets for VPC"
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "private_subnets" {
  type        = list(string)
  description = "Private subnets for VPC / EKS"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "node_instance_type" {
  type        = string
  description = "EC2 instance type for EKS nodes"
  default     = "t3.medium"
}

variable "desired_capacity" {
  type        = number
  default     = 3
}

variable "min_size" {
  type        = number
  default     = 2
}

variable "max_size" {
  type        = number
  default     = 5
}
