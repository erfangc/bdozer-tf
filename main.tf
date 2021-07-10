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

#
# the ECS services we will be running
#
module "web-server-a" {
  source              = "./ecs-service"
  vpc                 = module.vpc
  service_name        = "web-server-a"
  aws_lb_listener_arn = aws_lb_listener.lb-listener.arn
}

#
# the ECS services we will be running
#
module "web-server-a" {
  source              = "./ecs-service"
  vpc                 = module.vpc
  service_name        = "web-server-b"
  aws_lb_listener_arn = aws_lb_listener.lb-listener.arn
}
