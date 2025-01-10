# Cluster ECS
resource "aws_ecs_cluster" "main" {
  name = "main-cluster"
}

# Task Definition
resource "aws_ecs_task_definition" "web" {
  family                   = "web-app"
  requires_compatibilities = ["FARGATE"]
  network_mode            = "awsvpc"
  cpu                     = 1024
  memory                  = 2048

  container_definitions = jsonencode([
    {
      name      = "esgi-frontend"
      image     = "onlymore/esgi-frontend:latest"
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
  name            = "wordpress-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.web.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = [aws_subnet.private_a.id, aws_subnet.private_b.id]
    security_groups = [aws_security_group.ecs_tasks.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.web_tg.arn
    container_name   = "esgi-frontend"
    container_port   = 80
  }
}

# Auto Scaling Group pour ECS
resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = 4
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.web_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

# Règle de montée en charge basée sur l'utilisation CPU
resource "aws_appautoscaling_policy" "ecs_policy_cpu" {
  name               = "cpu-auto-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value       = 80.0  # Réduire cette valeur pour scaling plus agressif
    scale_in_cooldown  = 300   # Temps d'attente avant de réduire (en secondes)
    scale_out_cooldown = 60    # Temps d'attente avant d'augmenter
  }
}

# Règle de montée en charge basée sur l'utilisation mémoire
resource "aws_appautoscaling_policy" "ecs_policy_memory" {
  name               = "memory-auto-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value = 80.0  # Déclenche l'auto-scaling quand l'utilisation mémoire atteint 80%
  }
}


