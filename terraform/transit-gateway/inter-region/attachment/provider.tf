terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
      configuration_aliases = [ aws, aws.aws_r2 ]
    }
  }
}
