terraform {
  required_version = ">= 1.3"
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = ">= 3.0.0, <5.0.0"
    }
    github = {
        source = "integrations/github"
        version = "> 4.14"
    }
  }
}