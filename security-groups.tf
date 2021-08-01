resource "aws_security_group" "elasticsearch-domain-sg" {
  name = "elasticsearch"
  description = "Elasticsearch domain security group"
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group_rule" "elasticsearch-allow-https" {
  from_port = 443
  to_port = 443
  protocol = "tcp"
  security_group_id = aws_security_group.elasticsearch-domain-sg.id
  cidr_blocks = [
    module.vpc.vpc_cidr_block
  ]
  type = "ingress"
}

#
# the ALB's security group - which allow port 80 ingress only (and obviously should be able to talk to the VPC that it is fronting)
#
resource "aws_security_group" "alb-sg" {

  name = "alb-sg"
  description = "Security group for the Application load balancer"
  vpc_id = module.vpc.vpc_id

  ingress = [
    {
      cidr_blocks = [
        "0.0.0.0/0"
      ]
      ipv6_cidr_blocks = [
        "::/0"
      ]
      security_groups = []
      prefix_list_ids = []
      self = false,
      description = "Ingress from internet"
      from_port = 80
      protocol = "tcp"
      to_port = 80
    },
    {
      cidr_blocks = [
        "0.0.0.0/0"]
      ipv6_cidr_blocks = [
        "::/0"]
      security_groups = []
      prefix_list_ids = []
      self = false,
      description = "Ingress from internet vai SSL"
      from_port = 443
      protocol = "tcp"
      to_port = 443
    }
  ]

  egress = [
    {
      cidr_blocks = [
        module.vpc.vpc_cidr_block]
      ipv6_cidr_blocks = [
        "::/0"]
      security_groups = []
      prefix_list_ids = []
      self = false,
      description = "Egress to VPC"
      from_port = 0
      protocol = "tcp"
      to_port = 65535
    }]

  tags = {
    "Name" = "alb-sg"
  }
}
