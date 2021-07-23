locals {
  service_common_cfgs = {
    vpc_id = module.vpc.vpc_id
    vpc_cidr_block = module.vpc.vpc_cidr_block
    private_subnets = module.vpc.private_subnets
    cluster_id = var.env
    aws_lb_listener_arn = aws_lb_listener.lb-listener.arn
  }
}

#
# the ECS services we will be running
#
module "stock-valuation-service" {
  source = "./ecs-service"
  service_name = "stock-valuation-service"
  desired_count = 0

  service_common_configs = local.service_common_cfgs
}
