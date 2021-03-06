
resource "aws_security_group" "task-sg" {
  name        = "${var.service_name}-task-sg"
  description = "Security group for the ECS task"
  vpc_id      = var.service_common_configs.vpc_id

  ingress = [
    {
      cidr_blocks      = [var.service_common_configs.vpc_cidr_block]
      ipv6_cidr_blocks = []
      security_groups  = []
      prefix_list_ids  = []
      self             = false
      description      = "Ingress from same VPC"
      from_port        = 0
      protocol         = "tcp"
      to_port          = 65535
    }
  ]

  egress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    security_groups  = []
    prefix_list_ids  = []
    self             = false
    description      = "Egress to internet"
    from_port        = 0
    protocol         = "tcp"
    to_port          = 65535
  }]

  tags = {
    "Name" = "task-sg"
  }

}
