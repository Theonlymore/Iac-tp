# Cluster ECS
resource "aws_ecs_cluster" "main" {
  name = "main-cluster"
}

# Task Definition
resource "aws_ecs_task_definition" "web" {
  family                   = "web-app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512

  container_definitions = jsonencode([
    {
      name      = "web-app"
      image     = "nginx:latest"
      essential = true
      portMappings = [
        {
          containerPort = 80
          protocol      = "tcp"
        }
      ]
    }
  ])
}

# Service ECS
resource "aws_ecs_service" "web_service" {
  name            = "web-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.web.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.private_a.id, aws_subnet.private_b.id]
    security_groups  = [aws_security_group.web_sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.web_tg.arn
    container_name   = "web-app"
    container_port   = 80
  }
}


