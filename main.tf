provider "aws" { 
  region = "us-east-1" 
} 
 
terraform { 
  # Specify the required Terraform version
  required_version = ">= 1.0.0"

  # Specify provider and version
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" { 
    bucket = "sctp-ce11-tfstate" 
    key    = "marlon32.tfstate"  #Change this 
    region = "us-east-1" 
  } 
} 
 
data "aws_caller_identity" "current" {} 
 
locals { 
  name_prefix = "${split("/", "data.aws_caller_identity.current.arn)[1]}"  # "${split("/", "${data.aws_caller_identity.current.arn}")[1]}" 
  account_id  = data.aws_caller_identity.current.account_id 
} 
 
resource "aws_s3_bucket" "s3_tf" { 
  bucket = format("%s-s3-tf-bkt-%s", local.name_prefix, tostring(local.account_id)) # "${local.name_prefix}-s3-tf-bkt-${local.account_id}" 
}