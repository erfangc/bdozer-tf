resource "aws_instance" "main-server" {
  ami             = "ami-0e9d3c53b79c2cc6f"
  key_name        = "master-key-${var.env}"
  instance_type   = "c5.large"

  root_block_device {
    volume_size = 35
    iops = 200
  }
  
  vpc_security_group_ids = [aws_security_group.main-server.id]
  subnet_id = module.vpc.public_subnets[0]

  tags = {
    Name = "main-server"
  }
}

resource "aws_security_group" "main-server" {
  name        = "main-server"
  description = "Main server security group"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group_rule" "main-server-ssh-ingress" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.main-server.id
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "main-server-https-ingress" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.main-server.id
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "main-server-http-ingress" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.main-server.id
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "main-server-https-egress" {
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.main-server.id
  cidr_blocks = ["0.0.0.0/0"]
}
