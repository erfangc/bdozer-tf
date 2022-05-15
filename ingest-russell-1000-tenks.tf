resource "aws_ecs_task_definition" "ingest-russell-1000" {
  family                   = "ingest-russell-1000"
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
      command   = ["java", "-cp", "bdozer-api-batch-jobs-0.0.1-SNAPSHOT.jar", "co.bdozer.jobs.IngestRussell100TenKsKt"]
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
          awslogs-group         = "ingest-russell-1000"
          awslogs-region        = "us-east-1"
          awslogs-create-group  = "true"
          awslogs-stream-prefix = "ingest-russell-1000"
        }
      }
    },
  ])
}

//
// schedule the run
//
resource "aws_iam_role" "ingest-russell-1000-rule" {
  name = "ingest-russell-1000-rule"

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

resource "aws_iam_role_policy" "ingest-russell-1000-rule" {
  name = "ingest-russell-1000-rule"
  role = aws_iam_role.ingest-russell-1000-rule.id

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

resource "aws_cloudwatch_event_rule" "ingest-russell-1000-rule" {
  name                = "ingest-russell-1000-rule"
  schedule_expression = "rate(24 hours)"
}

resource "aws_cloudwatch_event_target" "ingest-russell-1000-rule" {
  target_id = "ingest-russell-1000-rule"
  arn       = aws_ecs_cluster.ecs-cluster.arn
  rule      = aws_cloudwatch_event_rule.ingest-russell-1000-rule.name
  role_arn  = aws_iam_role.ingest-russell-1000-rule.arn

  ecs_target {
    task_count          = 1
    task_definition_arn = aws_ecs_task_definition.ingest-russell-1000.arn
    launch_type         = "FARGATE"
    network_configuration {
      subnets          = module.vpc.public_subnets
      security_groups  = [module.vpc.default_security_group_id]
      assign_public_ip = true
    }
  }
}
