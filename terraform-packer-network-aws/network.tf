#############################################
#Creating Virtual Private Cloud:
#############################################

resource "aws_vpc" "packer_vpc" {
  cidr_block           = var.packer_vpc
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "Packer-VPC-Infrati"
  }
}

#############################################
# Creating Public subnet:
#############################################

resource "aws_subnet" "public_subnet_packer" {
  count                   = length(var.public_subnets_cidr_packer)
  vpc_id                  = aws_vpc.packer_vpc.id
  availability_zone       = data.aws_availability_zones.azs.names[count.index]
  cidr_block              = element(var.public_subnets_cidr_packer, count.index)
  map_public_ip_on_launch = "true"

  tags = {
    "Name" = "Public-Subnet-Packer-${count.index}"
  }
}

#############################################
# Creating Internet Gateway:
#############################################

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.packer_vpc.id

  tags = {
    "Name" = "Internet-Gateway"
  }
}

#############################################
# Creating Public Route Table Packer:
#############################################

resource "aws_route_table" "public_rt_packer" {
  vpc_id = aws_vpc.packer_vpc.id

  tags = {
    "Name" = "Public-RouteTable-Packer"
  }
}

#############################################
# Creating Public Route Packer:
#############################################

resource "aws_route" "public_route_packer" {
  route_table_id         = aws_route_table.public_rt_packer.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

#############################################
# Creating Public Route Table Association:
#############################################

resource "aws_route_table_association" "public_rt_association_packer" {
  depends_on     = [aws_route_table.public_rt_packer]
  count          = length(var.public_subnets_cidr_packer)
  route_table_id = aws_route_table.public_rt_packer.id
  subnet_id      = element(aws_subnet.public_subnet_packer.*.id, count.index)
}

############################################################################################
# Creating 1 Elastic IPs:
############################################################################################

resource "aws_eip" "eip" {
  count            = length(var.public_subnets_cidr_packer)
  public_ipv4_pool = "amazon"
  vpc              = true

  tags = {
    "Name" = "EIP-Packer"
  }
}

