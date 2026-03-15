resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/${var.name_prefix}-dispatch"
  retention_in_days = 7
}

resource "aws_ecs_cluster" "this" {
  name = "${var.name_prefix}-cluster"
}

resource "aws_ecs_task_definition" "dispatch" {
  family                   = "${var.name_prefix}-dispatch"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  task_role_arn            = aws_iam_role.ecs_task.arn

  container_definitions = jsonencode([
    {
      name      = "aws-cli"
      image     = "amazon/aws-cli"
      essential = true
      command = [
        "sns",
        "publish",
        "--topic-arn",
        var.verification_sns_topic_arn,
        "--message",
        local.ecs_sns_message,
        "--region",
        "us-east-1"
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}
