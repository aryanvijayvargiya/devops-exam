variable "subnet_cidrs" {
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24",
    "10.0.4.0/24"
  ]
}

resource "aws_subnet" "private_subnets" {
  count             = length(var.subnet_cidrs)
  vpc_id            = data.aws_vpc.vpc.id
  cidr_block        = var.subnet_cidrs[count.index]
}

resource "aws_route_table" "route_table_private" {
  vpc_id = data.aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = data.aws_nat_gateway.nat.id
  }
}

resource "aws_route_table_association" "route_table_association_private" {
  subnet_id      = aws_subnet.private_subnets[*].id
  route_table_id = aws_route_table.route_table_private.id
}

output "subnet_ids" {
  value = aws_subnet.private_subnets[*].id
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "lambda_function.py"
  output_path = "lambda_function.zip"
}

resource "aws_security_group" "lambda_sg" {
  name        = "lambda-security-group"
  description = "Security group for Lambda function"

  vpc_id = data.aws_vpc.vpc.id 
  // Allow inbound traffic
  ingress {
    description = "Allow HTTP inbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Allow outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_lambda_function" "lambda" {
  filename      = "lambda_function.zip"
  function_name = "DevOpsExamLambdaFunction"
  handler       = "lambda_function.lambda_handler"
  role          = data.aws_iam_role.lambda.arn
  runtime       = "python3.12"

  vpc_config {
    subnet_ids         = [aws_subnet.private_subnets[0].id]  # Replace with your subnet IDs
    security_group_ids = [aws_security_group.lambda_sg.id]   # Replace with your security group ID
  }
}
