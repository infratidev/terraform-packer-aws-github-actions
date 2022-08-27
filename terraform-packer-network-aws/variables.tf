#####################################################
# VPC Packer Requirement
#####################################################

variable "packer_vpc" {
  description = "VPC for packer environment"
  type        = string
  default     = "10.0.0.0/16"
}

#####################################################
# Region
#####################################################

variable "region" {
    description = "Default region"
    default = "us-east-1"
}

#####################################################
# Public subnet CIDR Bastion
#####################################################

variable "public_subnets_cidr_packer" {
  type        = list(any)
  description = "CIDR block for Public Subnet Packer"
  default     = ["10.0.200.0/24"]
}

