#
# the ALB's security group - which allow port 80 ingress only (and obviously should be able to talk to the VPC that it is fronting)
#
resource "aws_security_group" "alb-sg" {

  name        = "alb-sg"
  description = "Security group for the Application load balancer"
  vpc_id      = module.vpc.vpc_id

  ingress = [
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
    },
    {
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      security_groups  = []
      prefix_list_ids  = []
      self             = false,
      description      = "Ingress from internet vai SSL"
      from_port        = 443
      protocol         = "tcp"
      to_port          = 443
    }
  ]

  egress = [{
    cidr_blocks      = ["10.10.10.0/24"]
    ipv6_cidr_blocks = ["::/0"]
    security_groups  = []
    prefix_list_ids  = []
    self             = false,
    description      = "Egress to VPC"
    from_port        = 0
    protocol         = "tcp"
    to_port          = 65535
  }]

  tags = {
    "Name" = "alb-sg"
  }
}
