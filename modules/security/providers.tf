terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      configuration_aliases = [
        aws.tfg-test-account1-region1,
        aws.tfg-test-account1-region2
      ]
    }
  }
}
