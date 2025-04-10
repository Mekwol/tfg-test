# Share IPAM with the new account
resource "aws_ram_resource_share" "ipam_share" {
  provider                  = aws.delegated_account
  name                      = "ipam-resource-share"
  allow_external_principals = false
}

# Share Region 1 IPAM pools
resource "aws_ram_resource_association" "ipam_region1_pool_association" {
  provider           = aws.delegated_account
  resource_arn       = aws_vpc_ipam_pool.region1.arn
  resource_share_arn = aws_ram_resource_share.ipam_share.arn
}

resource "aws_ram_resource_association" "ipam_region1_prod_association" {
  provider           = aws.delegated_account
  resource_arn       = aws_vpc_ipam_pool.region1_prod.arn
  resource_share_arn = aws_ram_resource_share.ipam_share.arn
}

resource "aws_ram_resource_association" "ipam_region1_nonprod_association" {
  provider           = aws.delegated_account
  resource_arn       = aws_vpc_ipam_pool.region1_nonprod.arn
  resource_share_arn = aws_ram_resource_share.ipam_share.arn
}

resource "aws_ram_resource_association" "ipam_region1_prod_subnet1_association" {
  provider           = aws.delegated_account
  resource_arn       = aws_vpc_ipam_pool.region1_prod_subnet1.arn
  resource_share_arn = aws_ram_resource_share.ipam_share.arn
}

resource "aws_ram_resource_association" "ipam_region1_prod_subnet2_association" {
  provider           = aws.delegated_account
  resource_arn       = aws_vpc_ipam_pool.region1_prod_subnet2.arn
  resource_share_arn = aws_ram_resource_share.ipam_share.arn
}

resource "aws_ram_resource_association" "ipam_region1_nonprod_subnet1_association" {
  provider           = aws.delegated_account
  resource_arn       = aws_vpc_ipam_pool.region1_nonprod_subnet1.arn
  resource_share_arn = aws_ram_resource_share.ipam_share.arn
}

resource "aws_ram_resource_association" "ipam_region1_nonprod_subnet2_association" {
  provider           = aws.delegated_account
  resource_arn       = aws_vpc_ipam_pool.region1_nonprod_subnet2.arn
  resource_share_arn = aws_ram_resource_share.ipam_share.arn
}

# Share Region 2 IPAM pools
resource "aws_ram_resource_association" "ipam_region2_pool_association" {
  provider           = aws.delegated_account
  resource_arn       = aws_vpc_ipam_pool.region2.arn
  resource_share_arn = aws_ram_resource_share.ipam_share.arn
}

resource "aws_ram_resource_association" "ipam_region2_prod_association" {
  provider           = aws.delegated_account
  resource_arn       = aws_vpc_ipam_pool.region2_prod.arn
  resource_share_arn = aws_ram_resource_share.ipam_share.arn
}

resource "aws_ram_resource_association" "ipam_region2_nonprod_association" {
  provider           = aws.delegated_account
  resource_arn       = aws_vpc_ipam_pool.region2_nonprod.arn
  resource_share_arn = aws_ram_resource_share.ipam_share.arn
}

resource "aws_ram_resource_association" "ipam_region2_prod_subnet1_association" {
  provider           = aws.delegated_account
  resource_arn       = aws_vpc_ipam_pool.region2_prod_subnet1.arn
  resource_share_arn = aws_ram_resource_share.ipam_share.arn
}

resource "aws_ram_resource_association" "ipam_region2_prod_subnet2_association" {
  provider           = aws.delegated_account
  resource_arn       = aws_vpc_ipam_pool.region2_prod_subnet2.arn
  resource_share_arn = aws_ram_resource_share.ipam_share.arn
}

resource "aws_ram_resource_association" "ipam_region2_nonprod_subnet1_association" {
  provider           = aws.delegated_account
  resource_arn       = aws_vpc_ipam_pool.region2_nonprod_subnet1.arn
  resource_share_arn = aws_ram_resource_share.ipam_share.arn
}

resource "aws_ram_resource_association" "ipam_region2_nonprod_subnet2_association" {
  provider           = aws.delegated_account
  resource_arn       = aws_vpc_ipam_pool.region2_nonprod_subnet2.arn
  resource_share_arn = aws_ram_resource_share.ipam_share.arn
}

# Share with the newly created account
resource "aws_ram_principal_association" "ipam_account_principal" {
  provider           = aws.delegated_account
  principal          = aws_organizations_account.tfg-test-account1.id
  resource_share_arn = aws_ram_resource_share.ipam_share.arn
  depends_on         = [time_sleep.wait_for_account_ready]
}
