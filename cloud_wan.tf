# ------------------------------------------
# AWS Cloud WAN Core Network Configuration
# ------------------------------------------

# Create the AWS Cloud WAN Global Network
resource "aws_networkmanager_global_network" "global_network" {
  provider    = aws.delegated_account
  description = "TFG Global Network"
  
  tags = {
    Name        = "TFG-Global-Network"
    Environment = "Test"
  }
}

# Create the Core Network
resource "aws_networkmanager_core_network" "core_network" {
  provider          = aws.delegated_account
  global_network_id = aws_networkmanager_global_network.global_network.id
  description       = "TFG Core Network"
  
  tags = {
    Name        = "TFG-Core-Network"
    Environment = "Test"
  }
}

# Define a minimal valid Core Network Policy with edges

locals {
  initial_core_network_policy = jsonencode({
    version = "2021.12"
    core-network-configuration = {
      asn-ranges     = ["64512-65534"]
      edge-locations = ["us-east-1", "us-east-2"]
      edges = [
        {
          location            = "us-east-1"
          asn                 = 64512
          inside-cidr-blocks  = ["169.254.0.0/16"]
        },
        {
          location            = "us-east-2"
          asn                 = 64513
          inside-cidr-blocks  = ["169.254.0.0/16"]
        }
      ]
    }
    segments = [
      {
        name                           = "segment1"
        description                    = "Segment One"
        require-attachment-acceptance = false
      }
    ]
    attachment-policies = [
      {
        rule-number     = 100
        condition-logic = "or"
        conditions = [
          {
            type     = "tag-value"
            operator = "equals"
            key      = "Environment"
            value    = "Test"
          }
        ]
        action = {
          association-method = "constant"
          segment            = "segment1"
        }
      }
    ]
  })
}


# Attach the policy to the Core Network
resource "aws_networkmanager_core_network_policy_attachment" "policy_attachment" {
  provider        = aws.delegated_account
  core_network_id = aws_networkmanager_core_network.core_network.id
  policy_document = local.initial_core_network_policy
}

# Attach VPCs to the Core Network
resource "aws_networkmanager_vpc_attachment" "region1_prod_attachment" {
  provider        = aws.delegated_account
  subnet_arns     = [aws_subnet.region1_private_subnet1.arn]
  core_network_id = aws_networkmanager_core_network.core_network.id
  vpc_arn         = aws_vpc.region1_vpc.arn
  
  tags = {
    Name        = "Region1-VPC-Attachment"
    Environment = "Test"
  }
  
  depends_on = [aws_networkmanager_core_network_policy_attachment.policy_attachment]
}

resource "aws_networkmanager_vpc_attachment" "region2_prod_attachment" {
  provider        = aws.delegated_account
  subnet_arns     = [aws_subnet.region2_private_subnet1.arn]
  core_network_id = aws_networkmanager_core_network.core_network.id
  vpc_arn         = aws_vpc.region2_vpc.arn
  
  tags = {
    Name        = "Region2-VPC-Attachment"
    Environment = "Test"
  }
  
  depends_on = [aws_networkmanager_core_network_policy_attachment.policy_attachment]
}

# Add routes to route traffic through the Cloud WAN
resource "aws_route" "region1_private_to_cloudwan" {
  provider               = aws.tfg-test-account1-region1
  route_table_id         = aws_route_table.region1_private_rt.id
  destination_cidr_block = aws_vpc.region2_vpc.cidr_block
  core_network_arn       = aws_networkmanager_core_network.core_network.arn
  depends_on             = [aws_networkmanager_vpc_attachment.region1_prod_attachment]
}

resource "aws_route" "region2_private_to_cloudwan" {
  provider               = aws.tfg-test-account1-region2
  route_table_id         = aws_route_table.region2_private_rt.id
  destination_cidr_block = aws_vpc.region1_vpc.cidr_block
  core_network_arn       = aws_networkmanager_core_network.core_network.arn
  depends_on             = [aws_networkmanager_vpc_attachment.region2_prod_attachment]
}

