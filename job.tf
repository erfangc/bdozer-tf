resource "aws_iam_role" "ecsTaskExecutionRole" {
  assume_role_policy  = <<EOF
  {
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"]
}

resource "aws_ecs_task_definition" "ubuntu" {
  family                   = "ubuntu"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.main-server-role.arn
  container_definitions    = jsonencode([
    {
      name             = "default"
      image            = "ubuntu"
      essential        = true
      cmd              = ["echo", "-e", "Hello World"]
      logConfiguration = {
        logDriver = "awslogs",
        options   = {
          awslogs-group         = "ubuntu-container",
          awslogs-region        = "us-east-1",
          awslogs-create-group  = "true",
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
