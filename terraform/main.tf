provider "aws" {
  region = "eu-central-1"
}

resource "aws_vpc" "todo_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "todo_igw" {
  vpc_id = aws_vpc.todo_vpc.id
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.todo_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-central-1a"
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.todo_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.todo_igw.id
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}
