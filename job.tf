resource "aws_ecr_repository" "bdozer-api-batch-jobs" {
  name = "bdozer-api-batch-jobs"
}

resource "aws_ecs_task_definition" "sync-zacks-data" {
  family                   = "sync-zacks-data"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  container_definitions    = jsonencode([
    {
      name      = "default"
      image     = aws_ecr_repository.bdozer-api-batch-jobs.repository_url
      essential = true
      command   = ["echo", "-e", "Hello World"]
      secrets   = [
        { name : "ELASTICSEARCH_CREDENTIAL", valueFrom : aws_secretsmanager_secret.elasticsearch_credential.arn },
        { name : "ELASTICSEARCH_ENDPOINT", valueFrom : aws_secretsmanager_secret.elasticsearch_endpoint.arn },
        { name : "JDBC_PASSWORD", valueFrom : aws_secretsmanager_secret.jdbc_password.arn },
        { name : "JDBC_URL", valueFrom : aws_secretsmanager_secret.jdbc_url.arn },
        { name : "JDBC_USERNAME", valueFrom : aws_secretsmanager_secret.jdbc_username.arn },
        { name : "POLYGON_API_KEY", valueFrom : aws_secretsmanager_secret.polygon_api_key.arn },
        { name : "QUANDL_API_KEY", valueFrom : aws_secretsmanager_secret.quandl_api_key.arn },
      ],
      logConfiguration = {
        logDriver = "awslogs"
        options   = {
          awslogs-group         = "sync-zacks-data"
          awslogs-region        = "us-east-1"
          awslogs-create-group  = "true"
          awslogs-stream-prefix = "sync-zacks-data"
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
        Sid       = "123",
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

resource "aws_cloudwatch_event_rule" "sync-zacks-data-rule" {
  name                = "sync-zacks-data-rule"
  schedule_expression = "rate(12 hours)"
}

resource "aws_cloudwatch_event_target" "ecs_scheduled_task" {
  target_id = "run-scheduled-task-every-hour"
  arn       = aws_ecs_cluster.ecs-cluster.arn
  rule      = aws_cloudwatch_event_rule.sync-zacks-data-rule.name
  role_arn  = aws_iam_role.ecs_events.arn

  ecs_target {
    task_count          = 1
    task_definition_arn = aws_ecs_task_definition.sync-zacks-data.arn
    launch_type         = "FARGATE"
    network_configuration {
      subnets          = module.vpc.public_subnets
      security_groups  = [module.vpc.default_security_group_id]
      assign_public_ip = true
    }
  }
}
