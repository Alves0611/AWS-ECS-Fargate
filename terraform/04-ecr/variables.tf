variable "aws_region" {
  description = "AWS region where the Network resources will be deployed, e.g., 'eu-central-1' for the Europe (Frankfurt) region"
  type        = string
  default     = "eu-central-1"
}

variable "environment" {
  description = "Deployment environment name, such as 'dev', 'test', 'prod'. This categorizes the Network resources by their usage stage"
  type        = string
  default     = "dev"
}

variable "service_name" {
  description = "The name of the service the bastion host is associated with, used for naming and tagging resources in AWS"
  type        = string
  default     = "express-todo-api"
}

variable "department_name" {
  description = "Name of the department responsible for the VPC, e.g., 'engineering', 'marketing'. Helps in identifying ownership of the resources"
  type        = string
  default     = "devops"
}

variable "app_folder" {
  description = "Local filesystem path to the application's source code. This might be used for context in scripts or documentation. Default is '../../services/api'"
  type        = string
  default     = "../../services/api"
}

variable "force_delete_repo" {
  description = "Flag to determine whether the ECR repository should be forcefully deleted even if it contains images. Set to 'true' to enable force deletion"
  type        = bool
  default     = true
}
