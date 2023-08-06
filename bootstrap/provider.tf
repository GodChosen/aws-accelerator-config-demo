terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = {
      version = "~> 3.0"
      source  = "hashicorp/aws"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
  }

  #backend "s3" {}
}

provider "aws" {
  region  = var.region
  profile = var.profile
}

provider "aws" {
  region  = var.region
  alias   = "backend_state"
  profile = var.profile

}
