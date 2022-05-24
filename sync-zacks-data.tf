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
      command   = ["java", "-cp", "bdozer-api-batch-jobs-0.0.1-SNAPSHOT.jar", "co.bdozer.jobs.SyncZacksDataKt"]
      secrets   = [
        { name : "ELASTICSEARCH_CREDENTIAL", valueFrom : aws_secretsmanager_secret.elasticsearch_credential.arn },
        { name : "JDBC_PASSWORD", valueFrom : aws_secretsmanager_secret.jdbc_password.arn },
        { name : "POLYGON_API_KEY", valueFrom : aws_secretsmanager_secret.polygon_api_key.arn },
        { name : "QUANDL_API_KEY", valueFrom : aws_secretsmanager_secret.quandl_api_key.arn },
        { name : "CLIENT_ID", valueFrom : aws_secretsmanager_secret.client_id.arn },
        { name : "CLIENT_SECRET", valueFrom : aws_secretsmanager_secret.client_secret.arn },
      ],
      environment = [
        { name : "API_ENDPOINT", value: "https://api.bdozer.co" },
        { name : "ELASTICSEARCH_ENDPOINT", value: "https://elastic.bdozer.co" },
        { name : "JDBC_URL", value: "jdbc:postgresql://postgres.bdozer.co:5432/postgres" },
        { name : "JDBC_USERNAME", value: "postgres" },
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
resource "aws_iam_role" "sync-zacks-data-rule" {
  name = "sync-zacks-data-rule"

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

resource "aws_iam_role_policy" "sync-zacks-data-rule" {
  name = "sync-zacks-data-rule"
  role = aws_iam_role.sync-zacks-data-rule.id

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
  schedule_expression = "rate(24 hours)"
}

resource "aws_cloudwatch_event_target" "sync-zacks-data-rule" {
  target_id = "sync-zacks-data-rule"
  arn       = aws_ecs_cluster.ecs-cluster.arn
  rule      = aws_cloudwatch_event_rule.sync-zacks-data-rule.name
  role_arn  = aws_iam_role.sync-zacks-data-rule.arn

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
