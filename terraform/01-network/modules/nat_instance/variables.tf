variable "env" {
  description = "Designates the deployment environment (e.g., 'dev', 'test', 'prod'). This value can be used to differentiate resources across deployment stages."
  type        = string
  default     = "dev"
}

variable "vpc_id" {
  description = "Specifies the ID of the VPC where NAT instances will be deployed, ensuring network connectivity for resources within this VPC."
  type        = string
}

variable "vpc_name" {
  description = "Provides a default name for the VPC associated with NAT Instances, aiding in resource identification and organization."
  type        = string
  default     = "terraform-vpc"
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs where NAT instances will be placed, facilitating outbound internet access for private subnets."
  type        = list(string)
}


