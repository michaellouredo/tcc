terraform { 
  required_version = ">= 0.13"
  required_providers {
    aws = { 
      version = ">= 3.10.0"
    }
  }
  backend "s3" {
  bucket    = "unigranrio-terraform-states"
  region    = "us-east-1"
  key       = "tcc/unigranrio.state"
  }
}

provider "aws" { 
  region = var.region[terraform.workspace]
}
