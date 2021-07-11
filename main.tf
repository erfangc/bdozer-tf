#
# the ECS services we will be running
#
module "stock-valuation-service" {
  source       = "./ecs-service"
  service_name = "stock-valuation-service"

  vpc                 = module.vpc
  aws_lb_listener_arn = aws_lb_listener.lb-listener.arn
}
