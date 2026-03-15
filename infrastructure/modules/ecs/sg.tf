#tfsec:ignore:aws-ec2-no-public-egress-sgr Public subnet Fargate is an explicit cost optimization requirement for this assessment.
resource "aws_security_group" "ecs_task" {
  name        = "${var.name_prefix}-ecs-task"
  description = "Egress-only security group for Fargate tasks."
  vpc_id      = var.vpc_id

  egress {
    description = "Allow ECS tasks in public subnets to reach public AWS endpoints and image registries."
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-ecs-task"
  }
}
