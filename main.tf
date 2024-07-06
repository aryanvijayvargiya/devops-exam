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
  vpc_id            = "vpc-06b326e20d7db55f9"
  cidr_block        = var.subnet_cidrs[count.index]
}

output "subnet_ids" {
  value = aws_subnet.private_subnets[*].id
}

resource "aws_security_group" "lambda_sg" {
  name        = "lambda-security-group"
  description = "Security group for Lambda function"

  vpc_id = "vpc-06b326e20d7db55f9"  # Replace with your VPC ID

  // Allow inbound traffic
  // Example: Allow HTTP traffic
  ingress {
    description = "Allow HTTP inbound traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
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

resource "aws_lambda_function" "example_lambda" {
  filename      = "lambda_function.zip"
  function_name = "DevOpsExamLambdaFunction"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"

  vpc_config {
    subnet_ids         = [aws_subnet.private_subnets[0].id]  # Replace with your subnet IDs
    security_group_ids = [aws_security_group.lambda_sg.id]   # Replace with your security group ID
  }
}
