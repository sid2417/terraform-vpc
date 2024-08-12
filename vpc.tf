#### VPC ####
resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(var.common_tags,var.vpc_tags,
  {
    Name = local.resource_name
  })
}


#### IGW ####
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.common_tags,var.gw_tags,
  {
    Name = local.resource_name
  })
}

#### Public Subnet ####
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)
  availability_zone = local.az_names[count.index]
  map_public_ip_on_launch = true
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidrs[count.index]
  tags = merge(var.common_tags,var.public_subnet_tags,
  {
    Name = "${local.resource_name}-public-${local.az_names[count.index]}"
  })
}



#  az_names = slice(data.aws_availability_zones.available.names, 0, 2)

  # availability_zone = local.az_names[count.index]
  # map_public_ip_on_launch = true



#### Private Subnet ####
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  availability_zone = local.az_names[count.index]
  #map_public_ip_on_launch = true
  cidr_block = var.private_subnet_cidrs[count.index]

  tags = merge(var.common_tags,var.private_subnet_tags,
  {
    Name = "${local.resource_name}-private-${local.az_names[count.index]}"
  })
}



#### Database Subnet ####
resource "aws_subnet" "database" {
  count = length(var.database_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  availability_zone = local.az_names[count.index]
  cidr_block = var.database_subnet_cidrs[count.index]

  tags = merge(var.common_tags,var.database_subnet_tags,
  {
    Name = "${local.resource_name}-databse-${local.az_names[count.index]}"
  })
}



#### Elastic IP ####
resource "aws_eip" "elastic_ip" {
  domain   = "vpc"
}

#### NAT Gate Way ####
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.elastic_ip.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(var.common_tags,var.nat_gate_way_tags,{
    Name = local.resource_name
  })

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}



####  Public Route Table  ####
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = merge(var.common_tags,var.public_route_tags,
  {
    Name = "${local.resource_name}-public"
  })
}

####  Private Route Table  ####
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags = merge(var.common_tags,var.private_route_tags,
  {
    Name = "${local.resource_name}-private"
  })
}

####  Database Route Table  ####
resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id
  tags = merge(var.common_tags,var.database_route_tags,
  {
    Name = "${local.resource_name}-database"
  })
}




####  Public Routes   ####
resource "aws_route" "public" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/16"
  gateway_id = aws_internet_gateway.gw.id
  
}


####  Private Routes   ####
resource "aws_route" "private" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/16"
  gateway_id = aws_nat_gateway.nat.id
  
}


####  Database Routes   ####
resource "aws_route" "database" {
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = "0.0.0.0/16"
  gateway_id = aws_nat_gateway.nat.id
  
}


## element(list, index)
####  Routes and Subnets Association  ####
resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidrs)
  subnet_id = element(aws_subnet.public[*].id,count.index)
  route_table_id = aws_route_table.public.id
}


resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidrs)
  subnet_id      = element(aws_subnet.private[*].id,count.index)
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "database" {
  count = length(var.database_subnet_cidrs)
  subnet_id      = element(aws_subnet.database[*].id,count.index)
  route_table_id = aws_route_table.database.id
}
