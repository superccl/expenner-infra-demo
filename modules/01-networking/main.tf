locals {
  name_prefix = "${var.app_name}-${var.environment}"
  tags = {
    Tier        = "01-networking"
    Environment = var.environment
    Create_date = formatdate("YYYY-MM-DD", timestamp())
    Created_by  = "Terraform"
    Region      = var.region
  }
  selected_azs = slice(data.aws_availability_zones.available.names, 0, var.num_azs > 0 ? var.num_azs : length(data.aws_availability_zones.available.names))
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "main" {
  cidr_block                       = var.cidr_block
  enable_dns_hostnames             = true
  enable_dns_support               = true
  assign_generated_ipv6_cidr_block = true

  tags = merge(local.tags, {
    Name = "${var.app_name}-vpc"
  })
}

resource "aws_subnet" "web" {
  for_each                = { for idx, subnet in var.web_subnet_cidr : idx => subnet }
  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value
  ipv6_cidr_block         = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, each.key)
  availability_zone       = element(local.selected_azs, each.key)
  map_public_ip_on_launch = true

  tags = merge(local.tags, {
    Name = "${var.app_name}-web-${each.key + 1}"
  })
}

resource "aws_subnet" "application" {
  for_each          = { for idx, subnet in var.application_subnet_cidr : idx => subnet }
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  ipv6_cidr_block   = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, each.key + 16)
  availability_zone = element(local.selected_azs, each.key)

  tags = merge(local.tags, {
    Name = "${var.app_name}-app-${each.key + 1}"
  })
}

resource "aws_subnet" "database" {
  for_each          = { for idx, subnet in var.database_subnet_cidr : idx => subnet }
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  ipv6_cidr_block   = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, each.key + 32)
  availability_zone = element(local.selected_azs, each.key)

  tags = merge(local.tags, {
    Name = "${var.app_name}-db-${each.key + 1}"
  })
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.tags, {
    Name = "${var.app_name}-vpc-ig"
  })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.main.id
  }

  tags = merge(local.tags, {
    Name = "${var.app_name}-public-rt"
  })
}

resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.web
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id

}



