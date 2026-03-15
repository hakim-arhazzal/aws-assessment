resource "aws_security_group" "ecs_task" {
  name        = "${var.name_prefix}-ecs-task"
  description = "Egress-only security group for Fargate tasks."
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-ecs-task"
  }
}
