# resource "aws_cloudwatch_log_group" "web-server" {
#   name              = "web-server"
#   retention_in_days = 1
# }

# resource "aws_ecs_task_definition" "web-server" {
#   execution_role_arn = "arn:aws:iam::299541157397:role/ecsTaskExecutionRole"
#   family             = "web-server"
#   network_mode       = "awsvpc"

#   requires_compatibilities = ["FARGATE"]
#   cpu                      = 256
#   memory                   = 512
#   container_definitions    = templatefile("./ecs-task-definition.json.tpl", { region = "us-east-1" })
# }
