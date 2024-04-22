provider "aws" {
  region = "us-east-1" # Change to your desired region
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a" # Change to match desired availability zone
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b" # Change to match desired availability zone
}

resource "aws_security_group" "lambda_sg" {
  name        = "lambda_sg"
  description = "Allow HTTP access to Lambda function"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lambda_function" "my_lambda_function" {
  function_name = "my_lambda_function"
  description   = "My .NET Lambda Function"
  runtime       = "dotnetcore3.1"
  handler       = "MyNamespace::MyClass::MyMethod" # Change to your handler
  filename      = "path/to/your/lambda_function.zip" # Path to your Lambda function code
  source_code_hash = filebase64sha256("path/to/your/lambda_function.zip") # Calculate hash of your Lambda function code

  role          = aws_iam_role.lambda_role.arn # Add this line

  vpc_config {
    subnet_ids         = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
    security_group_ids = [aws_security_group.lambda_sg.id]
  }
}


resource "aws_api_gateway_rest_api" "my_api" {
  name = "My API"
}

resource "aws_api_gateway_resource" "my_api_resource" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  parent_id   = aws_api_gateway_rest_api.my_api.root_resource_id
  path_part   = "myapp"
}

resource "aws_api_gateway_method" "my_api_method" {
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  resource_id   = aws_api_gateway_resource.my_api_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "my_api_integration" {
  rest_api_id             = aws_api_gateway_rest_api.my_api.id
  resource_id             = aws_api_gateway_resource.my_api_resource.id
  http_method             = aws_api_gateway_method.my_api_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.my_lambda_function.invoke_arn
}

resource "aws_api_gateway_deployment" "my_api_deployment" {
  depends_on = [aws_api_gateway_integration.my_api_integration]
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  stage_name  = "prod"
}
