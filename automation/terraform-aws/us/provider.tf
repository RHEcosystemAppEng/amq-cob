terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# aws access key (+secret) id info (profile comes from ~/.aws/credentials)
provider "aws" {
  profile = "terraform_redhat"
  region = var.REGION
}
