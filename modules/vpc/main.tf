data "aws_availability_zones" "available" {
  state = "available"  # Fetch only available zones
}

#creating VPC

resource "aws_vpc" "this" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = var.vpc_tags
}

#creating Internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.this.id

  tags = var.vpc_tags
}

# Public Subnets
resource "aws_subnet" "alb_subnets" {
  count                   = length(var.alb_subnet_cidrs)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  cidr_block              = element(var.alb_subnet_cidrs, count.index)
  vpc_id                  = aws_vpc.this.id

  tags = merge({
    Name = "${var.environment}-alb-subnet-${data.aws_availability_zones.available.names[count.index]}-${count.index + 1}"
  }, var.additional_tags)
}

# Private Subnets
resource "aws_subnet" "app_subnets" {
  count             = length(var.app_subnet_cidrs)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = element(var.app_subnet_cidrs, count.index)
  vpc_id            = aws_vpc.this.id

  tags = {
    Name = "${var.environment}-app-subnet-${data.aws_availability_zones.available.names[count.index]}-${count.index + 1}"
  }
}

resource "aws_subnet" "db_subnets" {
  count             = length(var.db_subnet_cidrs)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = element(var.db_subnet_cidrs, count.index)
  vpc_id            = aws_vpc.this.id

  tags = {
    Name = "${var.environment}-db-subnet-${data.aws_availability_zones.available.names[count.index]}-${count.index + 1}"
  }
}

# create route table and add public route
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-public-route-table"
  }
}

# associate public subnet 1 to "public route table"
resource "aws_route_table_association" "public_subnet_route_table_association" {
  count          = length(var.alb_subnet_cidrs)
  subnet_id      = aws_subnet.alb_subnets[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

# associate private subnet 1 with "private route table"
resource "aws_route_table_association" "app_subnet_route_table_association" {
  count          = length(var.app_subnet_cidrs)
  subnet_id      = aws_subnet.app_subnets[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}

# create a new elastic IP for Nat Gateway
resource "aws_eip" "eip_for_nat_gateway" {
  domain = "vpc"

  tags = {
    Name = "${var.project_name}-nat-gateway"
  }
}

#creating nat gateway
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.eip_for_nat_gateway.id
  subnet_id     = element(aws_subnet.alb_subnets[*].id, var.index)

  tags = {
    Name = "${var.project_name}-nat-gateway"
  }

  depends_on = [aws_internet_gateway.gw]
}

# make the private route table as main route table
resource "aws_main_route_table_association" "aws_main_route_table" {
  vpc_id         = aws_vpc.this.id
  route_table_id = aws_route_table.private_route_table.id
}

# create private route table and add route through nat gateway
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = "${var.project_name}-private-route-table"
  }
}