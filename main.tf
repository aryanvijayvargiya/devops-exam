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

output "subnet_ids" {
  value = aws_subnet.private_subnets[*].id
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "lambda_function.py"
  output_path = "lambda_function.zip"
}

resource "aws_lambda_function" "lambda" {
  filename      = "lambda_function.zip"
  function_name = "DevOpsExamLambdaFunction"
  handler       = "lambda_function.lambda_handler"
  role          = data.aws_iam_role.lambda.arn
  runtime       = "python3.12"

  vpc_config {
    subnet_ids         = [aws_subnet.private_subnets[0].id]
    security_group_ids = [data.aws_security_group.sg.id]
  }
}
