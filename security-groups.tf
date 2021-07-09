resource "aws_security_group" "alb-sg" {
  name        = "alb-sg"
  description = "Security group for the Application load balancer"
  vpc_id      = module.vpc.vpc_id

  ingress = [
    {
      cidr_blocks      = ["10.10.10.0/24"]
      ipv6_cidr_blocks = []
      security_groups  = []
      prefix_list_ids  = []
      self             = false,
      description      = "Ingress from same VPC"
      from_port        = 0
      protocol         = "tcp"
      to_port          = 0
    },
    {
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      security_groups  = []
      prefix_list_ids  = []
      self             = false,
      description      = "Ingress from internet"
      from_port        = 80
      protocol         = "tcp"
      to_port          = 80
    }
  ]

  egress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    security_groups  = []
    prefix_list_ids  = []
    self             = false,
    description      = "Egress to internet"
    from_port        = 0
    protocol         = "tcp"
    to_port          = 0
  }]

  tags = {
    "Name" = "alb-sg"
  }
}

resource "aws_security_group" "task-sg" {
  name        = "task-sg"
  description = "Security group for the ECS task"
  vpc_id      = module.vpc.vpc_id

  ingress = [
    {
      cidr_blocks      = ["10.10.10.0/24"]
      ipv6_cidr_blocks = []
      security_groups  = []
      prefix_list_ids  = []
      self             = false,
      description      = "Ingress from same VPC"
      from_port        = 0
      protocol         = "tcp"
      to_port          = 0
    },
    {
      description = "Allow ALB to communicate with Task"
      security_groups : [aws_security_group.alb-sg.id]
      cidr_blocks      = []
      ipv6_cidr_blocks = []
      security_groups  = []
      prefix_list_ids  = []
      self             = false,
      from_port        = 80
      to_port          = 80
      protocol         = -1
    }
  ]

  tags = {
    "Name" = "task-sg"
  }
}
