resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

variable "subnet_cidrs" {
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24",
    "10.0.4.0/24",
    "10.0.5.0/24"
  ]
}

resource "aws_subnet" "private_subnets" {
  count             = length(var.subnet_cidrs)
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.subnet_cidrs[count.index]
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
}

data "aws_availability_zones" "available" {}

output "subnet_ids" {
  value = aws_subnet.private_subnets[*].id
}

