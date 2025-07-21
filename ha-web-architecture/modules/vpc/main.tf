resource "aws_vpc" "this" {
	cidr_block = var.vpc_cidr
	enable_dns_support = true
	enable_dns_hostnames = true

	tags = {
		Name = "${var.name}"
	}
}

resource "aws_internet_gateway" "this" {
	vpc_id = aws_vpc.this.id
}

#Public Subnets

resource "aws_subnet" "public" {
	count = length(var.public_subnet_cidrs)
	vpc_id = aws_vpc.this.id
	cidr_block = var.public_subnet_cidrs[count.index]
	availability_zone = var.azs[count.index]
	map_public_ip_on_launch = true
	tags = {
	Name = "${var.name}-public-${count.index + 1}"
	}
}

#Private Subnets

resource "aws_subnet" "private" {
	count = length(var.private_subnet_cidrs)
	vpc_id = aws_vpc.this.id
	cidr_block = var.private_subnet_cidrs[count.index]
	availability_zone = var.azs[count.index]
	map_public_ip_on_launch = false
	tags = {
	Name = "${var.name}-private-${count.index + 1}"
	}
}

#Elastic IPs for NAT 

resource "aws_eip" "nat" {
	count = length(var.private_subnet_cidrs)
	domain = "vpc"
}

#NAT Gateways

resource "aws_nat_gateway" "this" {
	count = length(var.public_subnet_cidrs)
	allocation_id = aws_eip.nat[count.index].id
	subnet_id = aws_subnet.public[count.index].id
	depends_on = [aws_internet_gateway.this]
}

#Private Route Tables

resource "aws_route_table" "private" {
	count = length(var.private_subnet_cidrs)
	vpc_id = aws_vpc.this.id
}

resource "aws_route" "private_nat" {
	count = length(var.private_subnet_cidrs)
	route_table_id = aws_route_table.private[count.index].id
	destination_cidr_block = "0.0.0.0/0"
	nat_gateway_id = aws_nat_gateway.this[count.index].id
}

resource "aws_route_table_association" "private" {
	count = length(aws_subnet.private)
	subnet_id = aws_subnet.private[count.index].id
	route_table_id = aws_route_table.private[count.index].id
}