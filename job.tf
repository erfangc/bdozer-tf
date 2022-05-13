resource "aws_ecs_task_definition" "ubuntu" {
  family                   = "ubuntu"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  container_definitions    = jsonencode([
    {
      name         = "default"
      image        = "ubuntu"
      cpu          = 10
      memory       = 512
      essential    = true
      cmd : ["echo", "-e", "Hello World"]
    },
  ])
}
