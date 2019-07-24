resource "aws_cloudwatch_log_group" "devops_app" {
  name              = "devops_app"
  retention_in_days = 1
}

resource "aws_ecs_task_definition" "devops_app" {
  family = "devops_app"

  container_definitions = <<EOF
[
  {
    "name": "devops_app",
    "image": "docker.io/yamanmcfly/devopsapp:v1",
    "cpu": 10,
    "memory": 128,
    "portMappings": [
      {
        "containerPort": 8000,
        "hostPort": 8000
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-region": "us-east-2",
        "awslogs-group": "devops_app",
        "awslogs-stream-prefix": "complete-ecs"
      }
    }
  }
]
EOF
}

resource "aws_ecs_service" "devops_app" {
  name = "devops_app"
  cluster = var.cluster_id
  task_definition = aws_ecs_task_definition.devops_app.arn

  desired_count = 1

  deployment_maximum_percent = 100
  deployment_minimum_healthy_percent = 0
}
