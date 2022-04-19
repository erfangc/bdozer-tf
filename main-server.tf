resource "aws_instance" "main-server" {
  ami             = "ami-0482730ee38e3f893"
  key_name        = "master-key-${var.env}"
  instance_type   = "c6g.large"
  security_groups = [aws_security_group.main-server.id]

  ebs_block_device {
    device_name = "data"
    volume_size = 50
  }

  tags = {
    Name = "main-server"
  }
}

resource "aws_security_group" "main-server" {
  name        = "main-server"
  description = "Main server security group"
  vpc_id      = module.vpc.vpc_id
}
