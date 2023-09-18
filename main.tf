terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "4.46.0"
    }
  }
}

# Configuar o provedor AWS
provider "aws" {
    region = "us-east-1"
}

provider "aws" {
  alias = "region-us-east-2"
  region = "us-east-2"  
}