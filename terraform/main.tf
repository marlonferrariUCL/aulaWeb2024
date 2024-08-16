provider "aws" {
  region = "us-east-1" # Altere a região conforme necessário
}

# Route 53 Hosted Zone
resource "aws_route53_zone" "example" {
  name = "example.com"
}

# Application Load Balancer
resource "aws_lb" "app_lb" {
  name               = "app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = aws_subnet.public[*].id
}

resource "aws_security_group" "lb_sg" {
  name_prefix = "lb_sg_"
  vpc_id      = aws_vpc.main.id
}

# API Gateway
resource "aws_api_gateway_rest_api" "api_gateway" {
  name        = "api-gateway"
  description = "API Gateway for the application"
}

# Lambda Functions
resource "aws_lambda_function" "web_lambda" {
  count = 3
  function_name = "web_lambda_${count.index + 1}"
  s3_bucket     = "my-lambda-functions"
  s3_key        = "lambda_function.zip"
  handler       = "index.handler"
  runtime       = "python3.8"
}

# RDS Database
resource "aws_db_instance" "db_primary" {
  identifier        = "userdb"
  instance_class    = "db.t3.micro"
  allocated_storage  = 20
  engine            = "mysql"
  username          = "admin"
  password          = "password"
  db_name           = "userdb"
  publicly_accessible = true
}

# ElastiCache
resource "aws_elasticache_cluster" "memcached" {
  cluster_id      = "memcached-cluster"
  node_type       = "cache.t3.micro"
  num_cache_nodes = 1
  engine          = "memcached"
}

# CloudWatch Logs
resource "aws_cloudwatch_log_group" "lambda_logs" {
  name = "/aws/lambda/my_lambda_function"
}

# Outputs
output "api_gateway_endpoint" {
  value = aws_api_gateway_rest_api.api_gateway.endpoint
}
