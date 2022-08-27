terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.27.0"
    }
  }

  backend "s3" {
    bucket          = "infrati-tfstate-packer-terraform" //S3 Bucket Name
    key             = "tf_network/terraform.tfstate"
    region          = "us-east-1"
    encrypt         = "true"
    dynamodb_table  = "infrati-tfstate-packer-network-lock" //DynamoDB Table Name    
  }

}

# Configure the AWS Provider
provider "aws" {
  region = var.region
}