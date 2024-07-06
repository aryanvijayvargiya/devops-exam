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

resource "null_resource" "install_layer_dependencies" {
  provisioner "local-exec" {
    command = "python3 -m pip install -r layer/requirements.txt "
  }
  triggers = {
    trigger = timestamp()
  }
}

data "archive_file" "layer_zip" {
  type        = "zip"
  source_dir  = "layer"
  output_path = "layer.zip"
  depends_on = [
    null_resource.install_layer_dependencies
  ]
}

resource "aws_lambda_layer_version" "lambda_layer" {
  filename = "layer.zip"
  source_code_hash = data.archive_file.layer_zip.output_base64sha256
  layer_name = "devops_exam_layer"

  compatible_runtimes = ["python3.12"]
  depends_on = [
    data.archive_file.layer_zip
  ]
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "lambda_function.py"
  output_path = "lambda_function.zip"
}

resource "aws_lambda_function" "lambda" {
  filename      = "lambda_function.zip"
  source_code_hash = data.archive_file.lambda.output_base64sha256
  layers = [
    aws_lambda_layer_version.lambda_layer.arn
  ]
  depends_on = [
    data.archive_file.lambda,
    aws_lambda_layer_version.lambda_layer
  ]
  function_name = "DevOpsExamLambdaFunction"
  handler       = "lambda_function.lambda_handler"
  role          = data.aws_iam_role.lambda.arn
  runtime       = "python3.12"

  vpc_config {
    subnet_ids         = [aws_subnet.private_subnets[0].id]
    security_group_ids = [data.aws_security_group.sg.id]
  }
}
