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
  source       = "./ecs-service"
  service_name = "web-server-a"

  vpc_id              = module.vpc.vpc_id
  subnets             = module.vpc.private_subnets
  aws_lb_listener_arn = aws_lb_listener.lb-listener.arn
}

#
# the ECS services we will be running
#
module "web-server-b" {
  source       = "./ecs-service"
  service_name = "web-server-b"

  vpc_id              = module.vpc.vpc_id
  subnets             = module.vpc.private_subnets
  aws_lb_listener_arn = aws_lb_listener.lb-listener.arn
}
