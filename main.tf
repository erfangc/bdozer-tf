locals {
  service_common_cfgs = {
    vpc_id              = module.vpc.vpc_id
    private_subnets     = module.vpc.private_subnets
    cluster_id          = var.env
    aws_lb_listener_arn = aws_lb_listener.lb-listener.arn
  }
}

#
# the ECS services we will be running
#
module "stock-valuation-service" {
  source        = "./ecs-service"
  service_name  = "stock-valuation-service"
  desired_count = 0

  service_common_cfgs = locals.service_common_cfgs
}
