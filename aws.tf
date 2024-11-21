resource "aws_vpc" "vpn_vpc" {
  cidr_block = "192.168.0.0/16"
}

resource "aws_subnet" "vpn_subnet" {
  vpc_id            = aws_vpc.vpn_vpc.id
  cidr_block        = "192.168.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_vpn_gateway" "vpn_gateway" {
  vpc_id = aws_vpc.vpn_vpc.id
}

resource "aws_customer_gateway" "cg" {
  bgp_asn    = 65000
  ip_address = azurerm_public_ip.vpn_gateway_ip.ip_address
  type       = "ipsec.1"
}

resource "aws_vpn_connection" "vpn_connection" {
  vpn_gateway_id      = aws_vpn_gateway.vpn_gateway.id
  customer_gateway_id = aws_customer_gateway.cg.id
  type                = "ipsec.1"

  static_routes_only = true


}

resource "aws_route_table" "vpn_route_table" {
  vpc_id = aws_vpc.vpn_vpc.id
  
  route {
    cidr_block = "172.16.1.0/24"
    gateway_id = aws_vpn_gateway.vpn_gateway.id
  }
}

resource "aws_route_table_association" "vpn_route_table_association" {
  subnet_id      = aws_subnet.vpn_subnet.id
  route_table_id = aws_route_table.vpn_route_table.id
}


resource "aws_security_group" "allow_icmp" {
  name        = "allow-icmp"
  description = "Allow ICMP traffic from Azure VPC"
  vpc_id      = aws_vpc.vpn_vpc.id

  ingress {
    from_port   = -1                       
    to_port     = -1                       
    protocol    = "icmp"
    cidr_blocks = ["172.16.1.0/24"]        
  }

  egress {
    from_port   = -1                       
    to_port     = -1                       
    protocol    = "icmp"
    cidr_blocks = ["172.16.1.0/24"]        
  }
}