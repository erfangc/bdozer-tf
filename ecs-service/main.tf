#
# ECR repo to upload docker images to for this service
#
resource "aws_ecr_repository" "ecr_repo" {
  name                 = var.service_name
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}

#
# Load balancer target group that will front all instances of this sesrvice
#
resource "aws_lb_target_group" "lb-tg" {
  name        = var.service_name
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
}

resource "aws_lb_listener_rule" "static" {
  listener_arn = var.aws_lb_listener_arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb-tg.arn
  }

  condition {
    path_pattern {
      values = ["/${var.service_name}/*"]
    }
  }
}

#
# Log group in CloudWatch where Logs will be ingested into
#
resource "aws_cloudwatch_log_group" "log_group" {
  name              = var.service_name
  retention_in_days = 7
}

resource "aws_ecs_task_definition" "task-definition" {

  execution_role_arn = "arn:aws:iam::299541157397:role/ecsTaskExecutionRole"
  family             = var.service_name
  network_mode       = "awsvpc"

  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  container_definitions    = templatefile("${path.module}/ecs-task-definition.json.tpl", { region = "us-east-1", service_name = "${var.service_name}", container_port = var.container_port })

}

resource "aws_ecs_service" "service" {

  name          = var.service_name
  desired_count = var.desired_count

  cluster = var.cluster_id

  # we keep the task definition at it's family name
  # as CICD processes will update this
  task_definition = var.service_name

  launch_type = "FARGATE"

  load_balancer {
    target_group_arn = aws_lb_target_group.lb-tg.arn
    container_name   = var.service_name
    container_port   = var.container_port
  }

  network_configuration {
    subnets         = var.subnets
    security_groups = [aws_security_group.task-sg.id]
  }

  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0

}
