resource "aws_ecs_task_definition" "ubuntu" {
  family                   = "ubuntu"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  container_definitions    = jsonencode([
    {
      name             = "default"
      image            = "ubuntu"
      essential        = true
      cmd              = ["echo", "-e", "Hello World"]
      logConfiguration = {
        logDriver = "awslogs",
        options   = {
          awslogs-group         = "ubuntu",
          awslogs-region        = "us-east-1",
          awslogs-stream-prefix = "ubuntu"
        }
      }
      #      portMappings = [
      #        {
      #          containerPort = 80
      #          hostPort      = 80
      #        }
      #      ]
    },
  ])
}
