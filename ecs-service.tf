resource "aws_ecs_service" "web-server" {
  name            = "web-server"
  cluster         = module.ecs.ecs_cluster_id
  task_definition = aws_ecs_task_definition.web-server.arn

  desired_count = 1

  launch_type = "FARGATE"

  load_balancer {
    target_group_arn = aws_lb_target_group.lb.arn
    container_name   = "web-server"
    container_port   = 80
  }

  network_configuration {
    subnets         = module.vpc.public_subnets
    security_groups = [aws_security_group.task-sg.id]
  }

  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0
}
