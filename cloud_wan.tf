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

# Define a minimal valid Core Network Policy

locals {
  initial_core_network_policy = jsonencode({
    version = "2021.12",
    "core-network-configuration" = {
      "vpn-ecmp-support" = true,
      "asn-ranges" = ["64512-64520"],
      "edge-locations" = [
        {
          location = "us-east-1",
          asn = 64512
        },
        {
          location = "us-east-2",
          asn = 64513
        }
      ]
    },
    segments = [
      {
        name = "prod",
        "require-attachment-acceptance" = false
      }
    ],
    "segment-actions" = [
      {
        action = "create-route",
        segment = "prod",
        "destination-cidr-blocks" = ["0.0.0.0/0"],
        "destinations" = ["blackhole"] 
      }
    ],
    "attachment-policies" = [
      {
        "rule-number" = 100,
        "condition-logic" = "or",
        "conditions" = [
          {
            "type" = "tag-value",
            "key" = "Environment",
            "operator" = "equals",
            "value" = "Test"
          }
        ],
        action = {
          "association-method" = "tag",
          "tag-value-of-key" = "Environment"
        }
      }
    ],
    "network-function-groups" = []
  })
}

# Attach the minimal policy to the Core Network
resource "aws_networkmanager_core_network_policy_attachment" "policy_attachment" {
  provider        = aws.delegated_account
  core_network_id = aws_networkmanager_core_network.core_network.id
  policy_document = local.initial_core_network_policy
}

# Attach VPCs to the Core Network 
resource "aws_networkmanager_vpc_attachment" "region1_prod_attachment" {
  provider        = aws.delegated_account
  subnet_arns     = [aws_subnet.delegated_private_subnet1_region1.arn]
  core_network_id = aws_networkmanager_core_network.core_network.id
  vpc_arn         = aws_vpc.delegated_vpc_region1.arn
  
  tags = {
    Name        = "Region1-VPC-Attachment"
    Environment = "Test"
  }
  
  depends_on = [aws_networkmanager_core_network_policy_attachment.policy_attachment]
}

resource "aws_networkmanager_vpc_attachment" "region2_prod_attachment" {
  provider        = aws.delegated_account-region2
  subnet_arns     = [aws_subnet.delegated_private_subnet1_region2.arn]
  core_network_id = aws_networkmanager_core_network.core_network.id
  vpc_arn         = aws_vpc.delegated_vpc_region2.arn
  
  tags = {
    Name        = "Region2-VPC-Attachment"
    Environment = "Test"
  }
  
  depends_on = [aws_networkmanager_core_network_policy_attachment.policy_attachment]
}


# Attache cloud_wan to tfg-test-account
#resource "aws_networkmanager_vpc_attachment" "tfg_test_account1_region1_attachment" {
 # provider        = aws.tfg-test-account1-region1
  #subnet_arns     = [aws_subnet.region1_private_subnet1.arn]
  #core_network_id = aws_networkmanager_core_network.core_network.id
  #vpc_arn         = aws_vpc.region1_vpc.arn
  
  #tags = {
   # Name        = "TFG-Test-Account1-Region1-VPC-Attachment"
    #Environment = "Test"
  #}
  
  #depends_on = [aws_networkmanager_core_network_policy_attachment.policy_attachment]
#}

#resource "aws_networkmanager_vpc_attachment" "tfg_test_account1_region2_attachment" {
 # provider        = aws.tfg-test-account1-region2
  #subnet_arns     = [aws_subnet.region2_private_subnet1.arn]
  #core_network_id = aws_networkmanager_core_network.core_network.id
  #vpc_arn         = aws_vpc.region2_vpc.arn
  
  #tags = {
   # Name        = "TFG-Test-Account1-Region2-VPC-Attachment"
    #Environment = "Test"
  #}
  
  #depends_on = [aws_networkmanager_core_network_policy_attachment.policy_attachment]
#}



# Data source to get the shared core network in region1
data "aws_networkmanager_core_network" "shared_core_network_region1" {
  provider = aws.tfg-test-account1-region1
  core_network_id = aws_networkmanager_core_network.core_network.id
  depends_on = [aws_ram_principal_association.cloudwan_account_principal]
}

# Data source to get the shared core network in region2
data "aws_networkmanager_core_network" "shared_core_network_region2" {
  provider = aws.tfg-test-account1-region2
  core_network_id = aws_networkmanager_core_network.core_network.id
  depends_on = [aws_ram_principal_association.cloudwan_account_principal]
}

# Create VPC attachments using the data sources
resource "aws_networkmanager_vpc_attachment" "tfg_test_account1_region1_attachment" {
  provider        = aws.tfg-test-account1-region1
  subnet_arns     = [aws_subnet.region1_private_subnet1.arn]
  core_network_id = data.aws_networkmanager_core_network.shared_core_network_region1.id
  vpc_arn         = aws_vpc.region1_vpc.arn
  
  tags = {
    Name        = "TFG-Test-Account1-Region1-VPC-Attachment"
    Environment = "Test"
  }
}

resource "aws_networkmanager_vpc_attachment" "tfg_test_account1_region2_attachment" {
  provider        = aws.tfg-test-account1-region2
  subnet_arns     = [aws_subnet.region2_private_subnet1.arn]
  core_network_id = data.aws_networkmanager_core_network.shared_core_network_region2.id
  vpc_arn         = aws_vpc.region2_vpc.arn
  
  tags = {
    Name        = "TFG-Test-Account1-Region2-VPC-Attachment"
    Environment = "Test"
  }
}
