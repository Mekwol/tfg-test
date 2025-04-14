# --------------------------
# Create Top-Level IPAM Pool for Region 1
# --------------------------
resource "aws_vpc_ipam_pool" "region1" {
  provider       = aws.delegated_account
  ipam_scope_id  = aws_vpc_ipam_scope.private_scope.id
  locale         = var.aws_regions[0]
  address_family = "ipv4"
  description    = "Top-Level Region 1 /16 Pool"
}

resource "aws_vpc_ipam_pool_cidr" "region1_cidr" {
  provider     = aws.delegated_account
  ipam_pool_id = aws_vpc_ipam_pool.region1.id
  cidr         = "10.0.0.0/16"
}

# --------------------------
# Create Pools for Production & Non-Production in Region 1
# --------------------------
resource "aws_vpc_ipam_pool" "region1_prod" {
  provider            = aws.delegated_account
  ipam_scope_id       = aws_vpc_ipam_scope.private_scope.id
  locale              = var.aws_regions[0]
  address_family      = "ipv4"
  description         = "Region 1 Production Pool"
  source_ipam_pool_id = aws_vpc_ipam_pool.region1.id
}

resource "aws_vpc_ipam_pool_cidr" "region1_prod_cidr" {
  provider     = aws.delegated_account
  ipam_pool_id = aws_vpc_ipam_pool.region1_prod.id
  cidr         = "10.0.0.0/17"
  depends_on   = [aws_vpc_ipam_pool_cidr.region1_cidr]
}

resource "aws_vpc_ipam_pool" "region1_nonprod" {
  provider            = aws.delegated_account
  ipam_scope_id       = aws_vpc_ipam_scope.private_scope.id
  locale              = var.aws_regions[0]
  address_family      = "ipv4"
  description         = "Region 1 Non-Production Pool"
  source_ipam_pool_id = aws_vpc_ipam_pool.region1.id
}

resource "aws_vpc_ipam_pool_cidr" "region1_nonprod_cidr" {
  provider     = aws.delegated_account
  ipam_pool_id = aws_vpc_ipam_pool.region1_nonprod.id
  cidr         = "10.0.128.0/17"
  depends_on   = [aws_vpc_ipam_pool_cidr.region1_cidr]
}

# --------------------------
# Create Sub-Pools for Each Environment in Region 1
# --------------------------
resource "aws_vpc_ipam_pool" "region1_prod_subnet1" {
  provider            = aws.delegated_account
  ipam_scope_id       = aws_vpc_ipam_scope.private_scope.id
  locale              = var.aws_regions[0]
  address_family      = "ipv4"
  description         = "Region 1 Production Subnet 1"
  source_ipam_pool_id = aws_vpc_ipam_pool.region1_prod.id
}

resource "aws_vpc_ipam_pool_cidr" "region1_prod_subnet1_cidr" {
  provider       = aws.delegated_account
  ipam_pool_id   = aws_vpc_ipam_pool.region1_prod_subnet1.id
  netmask_length = 21
  depends_on     = [aws_vpc_ipam_pool_cidr.region1_prod_cidr]
}

resource "aws_vpc_ipam_pool" "region1_prod_subnet2" {
  provider            = aws.delegated_account
  ipam_scope_id       = aws_vpc_ipam_scope.private_scope.id
  locale              = var.aws_regions[0]
  address_family      = "ipv4"
  description         = "Region 1 Production Subnet 2"
  source_ipam_pool_id = aws_vpc_ipam_pool.region1_prod.id
}

resource "aws_vpc_ipam_pool_cidr" "region1_prod_subnet2_cidr" {
  provider       = aws.delegated_account
  ipam_pool_id   = aws_vpc_ipam_pool.region1_prod_subnet2.id
  netmask_length = 21
  depends_on     = [aws_vpc_ipam_pool_cidr.region1_prod_cidr]
}

resource "aws_vpc_ipam_pool" "region1_nonprod_subnet1" {
  provider            = aws.delegated_account
  ipam_scope_id       = aws_vpc_ipam_scope.private_scope.id
  locale              = var.aws_regions[0]
  address_family      = "ipv4"
  description         = "Region 1 Non-Production Subnet 1"
  source_ipam_pool_id = aws_vpc_ipam_pool.region1_nonprod.id
}

resource "aws_vpc_ipam_pool_cidr" "region1_nonprod_subnet1_cidr" {
  provider       = aws.delegated_account
  ipam_pool_id   = aws_vpc_ipam_pool.region1_nonprod_subnet1.id
  netmask_length = 21
  depends_on     = [aws_vpc_ipam_pool_cidr.region1_nonprod_cidr]
}

resource "aws_vpc_ipam_pool" "region1_nonprod_subnet2" {
  provider            = aws.delegated_account
  ipam_scope_id       = aws_vpc_ipam_scope.private_scope.id
  locale              = var.aws_regions[0]
  address_family      = "ipv4"
  description         = "Region 1 Non-Production Subnet 2"
  source_ipam_pool_id = aws_vpc_ipam_pool.region1_nonprod.id
}

resource "aws_vpc_ipam_pool_cidr" "region1_nonprod_subnet2_cidr" {
  provider       = aws.delegated_account
  ipam_pool_id   = aws_vpc_ipam_pool.region1_nonprod_subnet2.id
  netmask_length = 21
  depends_on     = [aws_vpc_ipam_pool_cidr.region1_nonprod_cidr]
}
