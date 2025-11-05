# public_subnets
resource "aws_subnet" "public" {
  for_each = { for idx, cidr in var.public_subnets_cidr : idx => { cidr = cidr, az = var.availability_zones[idx] } }
  vpc_id                  = var.vpc_id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = true
  tags = merge(var.common_tags, {
    Name = "${var.name}-subnet-public-${each.key + 1}"
  })
}

# private_subnets
resource "aws_subnet" "private" {
  for_each = { for idx, cidr in var.private_subnets_cidr : idx => { cidr = cidr, az = var.availability_zones[idx] } }
  vpc_id            = var.vpc_id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az
  tags = merge(var.common_tags, {
    Name = "${var.name}-subnet-private-${each.key + 1}"
  })
}