{
  "executionRoleArn": "arn:aws:iam::299541157397:role/ecsTaskExecutionRole",
  "containerDefinitions": [
    {
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${service_name}",
          "awslogs-region": "us-east-1",
          "awslogs-stream-prefix": "complete-ecs"
        }
      },
      "portMappings": [
        {
          "hostPort": 8080,
          "protocol": "tcp",
          "containerPort": 8080
        }
      ],
      "cpu": 128,
      "environment": [],
      "mountPoints": [],
      "memory": 256,
      "volumesFrom": [],
      "image": "httpd:2.4",
      "essential": true,
      "name": "${service_name}"
    }
  ],
  "placementConstraints": [],
  "memory": "512",
  "family": "${service_name}",
  "requiresCompatibilities": [
    "FARGATE"
  ],
  "networkMode": "awsvpc",
  "cpu": "256",
  "volumes": []
}