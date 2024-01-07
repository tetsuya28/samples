resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    "Name"      = var.app
    "CreatedBy" = var.created_by
  }
}

data "aws_availability_zones" "this" {}

resource "aws_subnet" "public" {
  count  = var.subnet_count
  vpc_id = aws_vpc.this.id
  # + one octet based on vpc cidr range
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone       = data.aws_availability_zones.this.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    "Name"      = "${var.app}-public-${count.index}"
    "CreatedBy" = var.created_by
  }
}

resource "aws_subnet" "private" {
  count  = var.subnet_count
  vpc_id = aws_vpc.this.id
  # + one octet based on vpc cidr range
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index + 100)
  availability_zone       = data.aws_availability_zones.this.names[count.index]
  map_public_ip_on_launch = false
  tags = {
    "Name"      = "${var.app}-private-${count.index}"
    "CreatedBy" = var.created_by
  }
}
