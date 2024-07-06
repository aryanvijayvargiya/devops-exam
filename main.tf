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
  vpc_id            = "vpc-06b326e20d7db55f9"
  cidr_block        = var.subnet_cidrs[count.index]
}

output "subnet_ids" {
  value = aws_subnet.private_subnets[*].id
}

