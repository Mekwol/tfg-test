# ----------------------------------
# Delegated Account VPC Configuration
# ----------------------------------

# Create VPC in us-east-1 using the shared IPAM pool
resource "aws_vpc" "delegated_vpc_region1" {
  provider = aws.delegated_account

  # Use the Region 1 Non-Production Pool (using non-prod for delegated account)
  ipv4_ipam_pool_id   = aws_vpc_ipam_pool.region1_nonprod.id
  ipv4_netmask_length = 21 # Allocate a /21 CIDR block

  # Enable DNS support and hostnames for the VPC
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "Delegated-Account-VPC-Region1"
    Environment = "Test"
  }
}

# Create first public subnet in us-east-1 VPC
resource "aws_subnet" "delegated_public_subnet1_region1" {
  provider = aws.delegated_account
  vpc_id   = aws_vpc.delegated_vpc_region1.id

  cidr_block        = cidrsubnet(aws_vpc.delegated_vpc_region1.cidr_block, 2, 0) # /23 subnet
  availability_zone = "us-east-1a"

  # Enable auto-assign public IP for public subnet
  map_public_ip_on_launch = true

  tags = {
    Name        = "Delegated-Account-Public-Subnet1-Region1"
    Environment = "Test"
    Type        = "Public"
  }
}

# Create second public subnet in us-east-1 VPC
resource "aws_subnet" "delegated_public_subnet2_region1" {
  provider = aws.delegated_account
  vpc_id   = aws_vpc.delegated_vpc_region1.id

  cidr_block        = cidrsubnet(aws_vpc.delegated_vpc_region1.cidr_block, 2, 1) # /23 subnet
  availability_zone = "us-east-1b"

  # Enable auto-assign public IP for public subnet
  map_public_ip_on_launch = true

  tags = {
    Name        = "Delegated-Account-Public-Subnet2-Region1"
    Environment = "Test"
    Type        = "Public"
  }
}

# Create private subnet in us-east-1 VPC
resource "aws_subnet" "delegated_private_subnet1_region1" {
  provider = aws.delegated_account
  vpc_id   = aws_vpc.delegated_vpc_region1.id

  cidr_block        = cidrsubnet(aws_vpc.delegated_vpc_region1.cidr_block, 2, 2) # /23 subnet
  availability_zone = "us-east-1c"

  # Disable auto-assign public IP for private subnet
  map_public_ip_on_launch = false

  tags = {
    Name        = "Delegated-Account-Private-Subnet1-Region1"
    Environment = "Test"
    Type        = "Private"
  }
}

# ----------------------------------
# Region 2 VPC Configuration for Delegated Account
# ----------------------------------

# Create VPC in us-east-2 using the shared IPAM pool
resource "aws_vpc" "delegated_vpc_region2" {
  provider = aws.delegated_account-region2

  # Use the Region 2 Non-Production Pool
  ipv4_ipam_pool_id   = aws_vpc_ipam_pool.region2_nonprod.id
  ipv4_netmask_length = 21 # Allocate a /21 CIDR block

  # Enable DNS support and hostnames for the VPC
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "Delegated-Account-VPC-Region2"
    Environment = "Test"
  }
}

# Create first public subnet in us-east-2 VPC
resource "aws_subnet" "delegated_public_subnet1_region2" {
  provider = aws.delegated_account-region2
  vpc_id   = aws_vpc.delegated_vpc_region2.id

  cidr_block        = cidrsubnet(aws_vpc.delegated_vpc_region2.cidr_block, 2, 0) # /23 subnet
  availability_zone = "us-east-2a"

  # Enable auto-assign public IP for public subnet
  map_public_ip_on_launch = true

  tags = {
    Name        = "Delegated-Account-Public-Subnet1-Region2"
    Environment = "Test"
    Type        = "Public"
  }
}

# Create second public subnet in us-east-2 VPC
resource "aws_subnet" "delegated_public_subnet2_region2" {
  provider = aws.delegated_account-region2
  vpc_id   = aws_vpc.delegated_vpc_region2.id

  cidr_block        = cidrsubnet(aws_vpc.delegated_vpc_region2.cidr_block, 2, 1) # /23 subnet
  availability_zone = "us-east-2b"

  # Enable auto-assign public IP for public subnet
  map_public_ip_on_launch = true

  tags = {
    Name        = "Delegated-Account-Public-Subnet2-Region2"
    Environment = "Test"
    Type        = "Public"
  }
}

# Create private subnet in us-east-2 VPC
resource "aws_subnet" "delegated_private_subnet1_region2" {
  provider = aws.delegated_account-region2
  vpc_id   = aws_vpc.delegated_vpc_region2.id

  cidr_block        = cidrsubnet(aws_vpc.delegated_vpc_region2.cidr_block, 2, 2) # /23 subnet
  availability_zone = "us-east-2c"

  # Disable auto-assign public IP for private subnet
  map_public_ip_on_launch = false

  tags = {
    Name        = "Delegated-Account-Private-Subnet1-Region2"
    Environment = "Test"
    Type        = "Private"
  }
}


# ----------------------------------
# Delegated Account Networking Components - Region 1
# ----------------------------------

# Internet Gateway for Region 1
resource "aws_internet_gateway" "delegated_igw_region1" {
  provider = aws.delegated_account
  vpc_id   = aws_vpc.delegated_vpc_region1.id

  tags = {
    Name        = "Delegated-Account-IGW-Region1"
    Environment = "Test"
  }
}

# Elastic IP for NAT Gateway in Region 1
resource "aws_eip" "delegated_nat_eip_region1" {
  provider = aws.delegated_account
  domain   = "vpc"

  tags = {
    Name        = "Delegated-Account-NAT-EIP-Region1"
    Environment = "Test"
  }
}

# NAT Gateway for Region 1 - place in public subnet 1
resource "aws_nat_gateway" "delegated_nat_region1" {
  provider      = aws.delegated_account
  allocation_id = aws_eip.delegated_nat_eip_region1.id
  subnet_id     = aws_subnet.delegated_public_subnet1_region1.id

  tags = {
    Name        = "Delegated-Account-NAT-Region1"
    Environment = "Test"
  }

  depends_on = [aws_internet_gateway.delegated_igw_region1]
}

# Public Route Table for Region 1
resource "aws_route_table" "delegated_public_rt_region1" {
  provider = aws.delegated_account
  vpc_id   = aws_vpc.delegated_vpc_region1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.delegated_igw_region1.id
  }

  tags = {
    Name        = "Delegated-Account-Public-RT-Region1"
    Environment = "Test"
  }
}

# Private Route Table for Region 1
resource "aws_route_table" "delegated_private_rt_region1" {
  provider = aws.delegated_account
  vpc_id   = aws_vpc.delegated_vpc_region1.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.delegated_nat_region1.id
  }

  tags = {
    Name        = "Delegated-Account-Private-RT-Region1"
    Environment = "Test"
  }
}

# Public Subnet Associations for Region 1
resource "aws_route_table_association" "delegated_public_rta1_region1" {
  provider       = aws.delegated_account
  subnet_id      = aws_subnet.delegated_public_subnet1_region1.id
  route_table_id = aws_route_table.delegated_public_rt_region1.id
}

resource "aws_route_table_association" "delegated_public_rta2_region1" {
  provider       = aws.delegated_account
  subnet_id      = aws_subnet.delegated_public_subnet2_region1.id
  route_table_id = aws_route_table.delegated_public_rt_region1.id
}

# Private Subnet Association for Region 1
resource "aws_route_table_association" "delegated_private_rta1_region1" {
  provider       = aws.delegated_account
  subnet_id      = aws_subnet.delegated_private_subnet1_region1.id
  route_table_id = aws_route_table.delegated_private_rt_region1.id
}

# ----------------------------------
# Delegated Account Networking Components - Region 2
# ----------------------------------

# Internet Gateway for Region 2
resource "aws_internet_gateway" "delegated_igw_region2" {
 provider = aws.delegated_account-region2  
vpc_id   = aws_vpc.delegated_vpc_region2.id

  tags = {
    Name        = "Delegated-Account-IGW-Region2"
    Environment = "Test"
  }
}

# Elastic IP for NAT Gateway in Region 2
resource "aws_eip" "delegated_nat_eip_region2" {
  provider = aws.delegated_account-region2
  domain   = "vpc"

  tags = {
    Name        = "Delegated-Account-NAT-EIP-Region2"
    Environment = "Test"
  }
}

# NAT Gateway for Region 2 - place in public subnet 1
resource "aws_nat_gateway" "delegated_nat_region2" {
  provider      = aws.delegated_account-region2
  allocation_id = aws_eip.delegated_nat_eip_region2.id
  subnet_id     = aws_subnet.delegated_public_subnet1_region2.id

  tags = {
    Name        = "Delegated-Account-NAT-Region2"
    Environment = "Test"
  }

  depends_on = [aws_internet_gateway.delegated_igw_region2]
}

# Public Route Table for Region 2
resource "aws_route_table" "delegated_public_rt_region2" {
  provider = aws.delegated_account-region2
  vpc_id   = aws_vpc.delegated_vpc_region2.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.delegated_igw_region2.id
  }

  tags = {
    Name        = "Delegated-Account-Public-RT-Region2"
    Environment = "Test"
  }
}

# Private Route Table for Region 2
resource "aws_route_table" "delegated_private_rt_region2" {
  provider = aws.delegated_account-region2
  vpc_id   = aws_vpc.delegated_vpc_region2.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.delegated_nat_region2.id
  }

  tags = {
    Name        = "Delegated-Account-Private-RT-Region2"
    Environment = "Test"
  }
}

# Public Subnet Associations for Region 2
resource "aws_route_table_association" "delegated_public_rta1_region2" {
  provider       = aws.delegated_account-region2
  subnet_id      = aws_subnet.delegated_public_subnet1_region2.id
  route_table_id = aws_route_table.delegated_public_rt_region2.id
}

resource "aws_route_table_association" "delegated_public_rta2_region2" {
  provider       = aws.delegated_account-region2
  subnet_id      = aws_subnet.delegated_public_subnet2_region2.id
  route_table_id = aws_route_table.delegated_public_rt_region2.id
}

# Private Subnet Association for Region 2
resource "aws_route_table_association" "delegated_private_rta1_region2" {
  provider       = aws.delegated_account-region2
  subnet_id      = aws_subnet.delegated_private_subnet1_region2.id
  route_table_id = aws_route_table.delegated_private_rt_region2.id
}




# ----------------------------------
# Delegated Account Cloud WAN Attachments
# ----------------------------------

# Attach Delegated Account VPCs to the Core Network
#resource "aws_networkmanager_vpc_attachment" "delegated_region1_attachment" {
 # provider        = aws.delegated_account
 # subnet_arns     = [aws_subnet.delegated_private_subnet1_region1.arn]
  #core_network_id = aws_networkmanager_core_network.core_network.id
 # vpc_arn         = aws_vpc.delegated_vpc_region1.arn

  #tags = {
   # Name        = "Delegated-Region1-VPC-Attachment"
   # Environment = "Test"
 # }

  #depends_on = [aws_networkmanager_core_network_policy_attachment.policy_attachment]
#}

#resource "aws_networkmanager_vpc_attachment" "delegated_region2_attachment" {
 # provider        = aws.delegated_account
  #subnet_arns     = [aws_subnet.delegated_private_subnet1_region2.arn]
  #core_network_id = aws_networkmanager_core_network.core_network.id
  #vpc_arn         = aws_vpc.delegated_vpc_region2.arn

  #tags = {
   # Name        = "Delegated-Region2-VPC-Attachment"
    #Environment = "Test"
  #}

  #depends_on = [aws_networkmanager_core_network_policy_attachment.policy_attachment]
#}
