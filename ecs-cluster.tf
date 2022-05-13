resource "aws_cloudwatch_log_group" "ecs-cluster" {
  name = "ecs-cluster"
}

resource "aws_ecs_cluster" "ecs-cluster" {
  name               = "ecs-cluster"
  capacity_providers = ["FARGATE"]
  configuration {
    execute_command_configuration {
      logging    = "OVERRIDE"
      log_configuration {
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.ecs-cluster.name
      }
    }
  }
}
