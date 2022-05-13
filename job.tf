resource "aws_ecs_task_definition" "ubuntu" {
  family                   = "ubuntu"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  container_definitions    = jsonencode([
    {
      name         = "default"
      image        = "ubuntu"
      essential    = true
      cmd = ["echo", "-e", "Hello World"]
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group = "ubuntu-container",
          awslogs-region = "us-east-1",
          awslogs-create-group = "true",
          awslogs-stream-prefix = "ecs"
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
