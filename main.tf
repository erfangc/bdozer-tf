#
# the ECS services we will be running
#
module "web-server-a" {
  source       = "./ecs-service"
  service_name = "web-server-a"

  vpc                 = module.vpc
  aws_lb_listener_arn = aws_lb_listener.lb-listener.arn
}

#
# the ECS services we will be running
#
module "web-server-b" {
  source       = "./ecs-service"
  service_name = "web-server-b"

  vpc                 = module.vpc
  aws_lb_listener_arn = aws_lb_listener.lb-listener.arn
}
