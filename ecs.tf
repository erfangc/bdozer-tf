module "ecs" {
  source             = "terraform-aws-modules/ecs/aws"
  name               = "dev"
  container_insights = true
  capacity_providers = ["FARGATE"]
  tags = {
    Environment = "Development"
  }
}
