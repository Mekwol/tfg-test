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

locals {
  region1 = var.aws_regions[0]
  region2 = var.aws_regions[1]
}

module "organization" {
  source = "./modules/organization"
  
  aws_regions         = var.aws_regions
  tfg_test_account1_id = var.tfg_test_account1_id
  root_ou_id          = var.root_ou_id
  
  providers = {
    aws.tfg-test-account1-region1 = aws.tfg-test-account1-region1
    aws.tfg-test-account1-region2 = aws.tfg-test-account1-region2
  }
}

module "ipam" {
  source = "./modules/ipam"
  
  aws_regions          = var.aws_regions
  delegated_account_id = var.delegated_account_id
  tfg_test_account1_id = var.tfg_test_account1_id
  
  providers = {
    aws.delegated_account = aws.delegated_account
  }
  
  depends_on = [module.organization]
}

module "network" {
  source = "./modules/network"
  
  aws_regions         = var.aws_regions
  tfg_test_account1_id = var.tfg_test_account1_id
  
  providers = {
    aws.tfg-test-account1-region1 = aws.tfg-test-account1-region1
    aws.tfg-test-account1-region2 = aws.tfg-test-account1-region2
  }
  
  depends_on = [module.ipam]
}

module "security" {
  source = "./modules/security"
  
  aws_regions         = var.aws_regions
  tfg_test_account1_id = var.tfg_test_account1_id
  my_ip               = var.my_ip
  linux_ip            = var.linux_ip
  
  vpc_id_region1      = module.network.vpc_id_region1
  
  providers = {
    aws.tfg-test-account1-region1 = aws.tfg-test-account1-region1
    aws.tfg-test-account1-region2 = aws.tfg-test-account1-region2
  }
}

module "compute" {
  source = "./modules/compute"
  
  aws_regions         = var.aws_regions
  tfg_test_account1_id = var.tfg_test_account1_id
  
  public_subnet_id    = module.network.public_subnet_id_region1
  private_subnet_id   = module.network.private_subnet_id_region1
  bastion_sg_id       = module.security.bastion_sg_id
  private_sg_id       = module.security.private_sg_id
  
  providers = {
    aws.tfg-test-account1-region1 = aws.tfg-test-account1-region1
    aws.tfg-test-account1-region2 = aws.tfg-test-account1-region2
  }
}
