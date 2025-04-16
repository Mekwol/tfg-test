# Define locals for organization and clarity
locals {
  ipam_pools = {
    # Region 1 pools
    region1 = {
      arn = aws_vpc_ipam_pool.region1.arn
    }
    region1_prod = {
      arn = aws_vpc_ipam_pool.region1_prod.arn
    }
    region1_nonprod = {
      arn = aws_vpc_ipam_pool.region1_nonprod.arn
    }
    region1_prod_subnet1 = {
      arn = aws_vpc_ipam_pool.region1_prod_subnet1.arn
    }
    region1_prod_subnet2 = {
      arn = aws_vpc_ipam_pool.region1_prod_subnet2.arn
    }
    region1_nonprod_subnet1 = {
      arn = aws_vpc_ipam_pool.region1_nonprod_subnet1.arn
    }
    region1_nonprod_subnet2 = {
      arn = aws_vpc_ipam_pool.region1_nonprod_subnet2.arn
    }
    
    # Region 2 pools
    region2 = {
      arn = aws_vpc_ipam_pool.region2.arn
    }
    region2_prod = {
      arn = aws_vpc_ipam_pool.region2_prod.arn
    }
    region2_nonprod = {
      arn = aws_vpc_ipam_pool.region2_nonprod.arn
    }
    region2_prod_subnet1 = {
      arn = aws_vpc_ipam_pool.region2_prod_subnet1.arn
    }
    region2_prod_subnet2 = {
      arn = aws_vpc_ipam_pool.region2_prod_subnet2.arn
    }
    region2_nonprod_subnet1 = {
      arn = aws_vpc_ipam_pool.region2_nonprod_subnet1.arn
    }
    region2_nonprod_subnet2 = {
      arn = aws_vpc_ipam_pool.region2_nonprod_subnet2.arn
    }
  }
}

# Share IPAM with the new account
resource "aws_ram_resource_share" "ipam_share" {
  provider                  = aws.delegated_account
  name                      = "ipam-resource-share"
  allow_external_principals = false
  
  tags = {
    Name        = "ipam-resource-share"
    Environment = "shared"
    ManagedBy   = "terraform"
  }
}

# Associate all IPAM pools using for_each
resource "aws_ram_resource_association" "ipam_pool_associations" {
  for_each           = local.ipam_pools
  provider           = aws.delegated_account
  resource_arn       = each.value.arn
  resource_share_arn = aws_ram_resource_share.ipam_share.arn
}

# Share with the newly created account
resource "aws_ram_principal_association" "ipam_account_principal" {
  provider           = aws.delegated_account
  principal          = aws_organizations_account.tfg-test-account1.id
  resource_share_arn = aws_ram_resource_share.ipam_share.arn
  depends_on         = [time_sleep.wait_for_account_ready]
}


#########################################################################################

# Share Cloud WAN Core Network
resource "aws_ram_resource_share" "cloudwan_share" {
  provider                  = aws.delegated_account
  name                      = "cloudwan-resource-share"
  allow_external_principals = false
  
  tags = {
    Name        = "cloudwan-resource-share"
    Environment = "shared"
    ManagedBy   = "terraform"
  }
}

# Associate Cloud WAN Core Network with RAM share
resource "aws_ram_resource_association" "cloudwan_association" {
  provider           = aws.delegated_account
  resource_arn       = aws_networkmanager_core_network.core_network.arn
  resource_share_arn = aws_ram_resource_share.cloudwan_share.arn
}

# Share with the test account
resource "aws_ram_principal_association" "cloudwan_account_principal" {
  provider           = aws.delegated_account
  principal          = aws_organizations_account.tfg-test-account1.id
  resource_share_arn = aws_ram_resource_share.cloudwan_share.arn
  depends_on         = [time_sleep.wait_for_account_ready]
}



















