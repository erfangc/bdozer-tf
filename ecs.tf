module "ecs" {
  source             = "terraform-aws-modules/ecs/aws"
  name               = var.env
  container_insights = true
  capacity_providers = ["FARGATE"]
}
