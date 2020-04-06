/*
Locking down the ingress CIDR range to something more appropriate than 0.0.0.0/0
*/

resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name        = "${var.name}-vpc"
    Environment = var.environment
  }
}

resource "aws_default_route_table" "this" {
  default_route_table_id = aws_vpc.this.default_route_table_id
}

resource "aws_default_network_acl" "default" {
  default_network_acl_id = aws_vpc.this.default_network_acl_id
}

resource "aws_subnet" "public" {
  for_each                = var.az_public_subnet
  cidr_block              = each.value
  vpc_id                  = aws_vpc.this.id
  availability_zone       = each.key
  map_public_ip_on_launch = true
  tags = {
    Name        = format("%s-public-%s", var.name, substr(each.key, -1, 1))
    Environment = var.environment
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name        = format("%s-igw", var.name)
    Environment = var.environment
  }
}

resource "aws_nat_gateway" "public" {
  for_each      = aws_subnet.public
  subnet_id     = each.value.id
  allocation_id = aws_eip.public[each.key].id
  tags = {
    Name        = format("%s-natgw", var.name)
    Environment = var.environment
  }
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_eip" "public" {
  for_each = aws_subnet.public
  vpc      = true
  tags = {
    Name        = format("%s-eip", var.name)
    Environment = var.environment
  }
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name        = format("%s-public", var.name)
    Environment = var.environment
  }
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public" {
  count          = length(var.az_public_subnet)
  subnet_id      = element(values(aws_subnet.public)[*].id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "private" {
  for_each          = var.az_private_subnet
  cidr_block        = each.value
  vpc_id            = aws_vpc.this.id
  availability_zone = each.key
  tags = {
    Name        = format("%s-private-%s", var.name, substr(each.key, -1, 1))
    Environment = var.environment
  }
}

resource "aws_route_table" "private" {
  for_each = var.az_private_subnet
  vpc_id   = aws_vpc.this.id
  tags = {
    Name        = format("%s-private-%s", var.name, substr(each.key, -1, 1))
    Environment = var.environment
  }
}

resource "aws_route" "default" {
  count = length(aws_subnet.private)
  route_table_id = element(values(aws_route_table.private)[*].id,
  count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = element(values(aws_nat_gateway.public)[*].id,
  count.index)
}

resource "aws_route_table_association" "private" {
  count          = length(var.az_private_subnet)
  subnet_id      = element(values(aws_subnet.private)[*].id, count.index)
  route_table_id = element(values(aws_route_table.private)[*].id, count.index)
}

resource "aws_flow_log" "this" {
  count                = var.enable_flow_log == true ? 1 : 0
  log_destination_type = "s3"
  log_destination      = var.loggingBucket
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.this.id
}
