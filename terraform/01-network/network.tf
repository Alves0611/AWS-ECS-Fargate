resource "aws_vpc" "this" {
  cidr_block           = var.network.cidr_block
  enable_dns_support   = local.enable_dns_support
  enable_dns_hostnames = local.enable_dns_hostnames

  tags = {
    "Name" = local.namespaced_department_name
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    "Name" = local.namespaced_department_name
  }
}

resource "aws_subnet" "private" {
  count = var.network.az_count

  availability_zone = local.selected_availability_zones[count.index]
  vpc_id            = aws_vpc.this.id

  tags = {
    "Name" = "${local.namespaced_department_name}-private-${local.selected_availability_zones[count.index]}"
  }
}

resource "aws_subnet" "public" {
  count = var.network.az_count

  cidr_block        = cidrsubnet(aws_vpc.this.cidr_block, 8, var.network.az_count + count.index)
  availability_zone = local.selected_availability_zones[count.index]
  vpc_id            = aws_vpc.this.id

  tags = {
    "Name" = "${local.namespaced_department_name}-public-${local.selected_availability_zones[count.index]}"
  }
}
