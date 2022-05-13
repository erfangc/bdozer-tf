resource "aws_ecs_task_definition" "ubuntu" {
  family                   = "ubuntu"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 10
  memory                   = 512
  container_definitions    = jsonencode([
    {
      name         = "default"
      image        = "ubuntu"
      essential    = true
      cmd : ["echo", "-e", "Hello World"]
#      portMappings = [
#        {
#          containerPort = 80
#          hostPort      = 80
#        }
#      ]
    },
  ])
}
