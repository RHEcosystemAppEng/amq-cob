terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# aws access key (+secret) id info (profile comes from ~/.aws/credentials)
provider "aws" {  // for 1st region
  #  shared_config_files      = ["/Users/tf_user/.aws/conf"]
  #  shared_credentials_files = ["/Users/tf_user/.aws/creds"]
  profile = "terraform_redhat"
  region = var.REGION
}

