resource "aws_ecs_task_definition" "ubuntu" {
  family = "ubuntu"
  container_definitions = jsonencode([
    {
      name      = "default"
      image     = "ubuntu"
      cpu       = 10
      memory    = 512
      essential = true
      cmd: ["echo", "-e", "Hello World"]
      portMappings = [
        {
        }
      ]
    },
  ])
}
