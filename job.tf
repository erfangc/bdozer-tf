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
      command          = ["echo", "-e", "Hello World"]
      logConfiguration = {
        logDriver = "awslogs"
        options   = {
          awslogs-group         = "ubuntu"
          awslogs-region        = "us-east-1"
          awslogs-create-group  = "true"
          awslogs-stream-prefix = "ubuntu"
        }
      }
    },
  ])
}

//
// schedule the run
//
resource "aws_iam_role" "ecs_events" {
  name = "ecs_events"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Sid       = "",
        Effect    = "Allow",
        Principal = {
          Service = "events.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "ecs_events_run_task_with_any_role" {
  name = "ecs_events_run_task_with_any_role"
  role = aws_iam_role.ecs_events.id

  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "iam:PassRole",
        Resource = "*"
      },
      {
        Effect   = "Allow",
        Action   = "ecs:RunTask",
        Resource = "*"
      }
    ]
  })
}

resource "aws_cloudwatch_event_rule" "every_5_minutes" {
  name                = "every_5_minutes"
  schedule_expression = "rate(5 minutes)"
}

resource "aws_cloudwatch_event_target" "ecs_scheduled_task" {
  target_id = "run-scheduled-task-every-hour"
  arn       = aws_ecs_cluster.ecs-cluster.arn
  rule      = aws_cloudwatch_event_rule.every_5_minutes.name
  role_arn  = aws_iam_role.ecs_events.arn

  ecs_target {
    task_count          = 1
    task_definition_arn = aws_ecs_task_definition.ubuntu.arn
    launch_type         = "FARGATE"
    network_configuration {
      subnets         = module.vpc.public_subnets
      security_groups = [module.vpc.default_security_group_id]
    }
  }
}
