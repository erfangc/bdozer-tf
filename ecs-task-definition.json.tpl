[
  {
    "name": "web-server",
    "image": "httpd:2.4",
    "cpu": 128,
    "memory": 256,
    "portMappings": [
        {
          "containerPort": 80,
          "hostPort": 80
        }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-region": "$region",
        "awslogs-group": "web-server",
        "awslogs-stream-prefix": "complete-ecs"
      }
    }
  }
]