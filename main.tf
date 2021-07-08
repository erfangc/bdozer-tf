terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.48.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.2.0"

  name               = "ecs-vpc"
  cidr               = "10.10.10.0/24"
  azs                = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets    = ["10.10.10.0/27", "10.10.10.32/27", "10.10.10.64/27"]
  public_subnets     = ["10.10.10.96/27", "10.10.10.128/27", "10.10.10.160/27"]
  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Owner       = "user"
    Environment = "Development"
  }
}

module "ecs" {
  source             = "terraform-aws-modules/ecs/aws"
  name               = "my-ecs"
  container_insights = true
  capacity_providers = ["FARGATE"]

  tags = {
    Environment = "Development"
  }
}

resource "aws_cloudwatch_log_group" "web-server" {
  name              = "web-server"
  retention_in_days = 1
}

resource "aws_ecs_task_definition" "web-server" {
  family = "web-server"

  container_definitions = templatefile("./ecs-task-definition.json.tpl", { region = "us-east-1" })
}

resource "aws_lb_target_group" "lb" {
  name        = "web-server-lb"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_ecs_service" "web-server" {
  name            = "web-server"
  cluster         = module.ecs.ecs_cluster_id
  task_definition = aws_ecs_task_definition.web-server.arn

  desired_count = 1

  load_balancer {
    target_group_arn = aws_lb_target_group.lb.arn
    container_name   = "web-server"
    container_port   = 80
  }

  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0
}
