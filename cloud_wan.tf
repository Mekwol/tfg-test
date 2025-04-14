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

# Define the Core Network Policy Document
resource "aws_networkmanager_core_network_policy_document" "policy" {
  core_network_configuration {
    asn_ranges       = ["64512-65534"]
    edge_locations   = ["us-east-1", "us-east-2"]
    vpn_ecmp_support = true
  }

  segments {
    name                          = "prod"
    description                   = "Production Segment"
    require_attachment_acceptance = false
  }

  segments {
    name                          = "nonprod"
    description                   = "Non-Production Segment"
    require_attachment_acceptance = false
  }

  segment_actions {
    action                 = "create-route"
    segment                = "prod"
    destination_cidr_blocks = ["0.0.0.0/0"]
    destinations           = ["attachment-${aws_networkmanager_vpc_attachment.region1_prod_attachment.id}"]
  }

  segment_actions {
    action                 = "create-route"
    segment                = "nonprod"
    destination_cidr_blocks = ["0.0.0.0/0"]
    destinations           = ["attachment-${aws_networkmanager_vpc_attachment.region2_prod_attachment.id}"]
  }

  attachment_policies {
    rule_number     = 100
    condition_logic = "or"
    
    conditions {
      type     = "tag-value"
      operator = "equals"
      key      = "Environment"
      value    = "Production"
    }
    
    action {
      association_method = "constant"
      segment           = "prod"
    }
  }

  attachment_policies {
    rule_number     = 200
    condition_logic = "or"
    
    conditions {
      type     = "tag-value"
      operator = "equals"
      key      = "Environment"
      value    = "Test"
    }
    
    action {
      association_method = "constant"
      segment           = "nonprod"
    }
  }
}

# Attach the policy to the Core Network
resource "aws_networkmanager_core_network_policy_attachment" "policy_attachment" {
  provider        = aws.delegated_account
  core_network_id = aws_netwo
