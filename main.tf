terraform {
 
    backend "remote" {
     organization = "TFG-Test"
       workspaces {
       name = "tfg-test-workspace"
     }
    }

   required_providers {
    aws = {
      source  = "hashicorp/aws"
     # version = "~> 5.20"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.9.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }
}







