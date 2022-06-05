#resource "aws_instance" "gpu-sandbox" {
#  
#  ami = "ami-00ab1614b421d5575"
#  key_name      = "master-key-${var.env}"
#  instance_type = "g5.xlarge"
#  
#  root_block_device {
#    volume_size = 250
#    iops        = 4000
#  }
#
#  vpc_security_group_ids = [aws_security_group.gpu-sandbox.id]
#  subnet_id              = module.vpc.public_subnets[0]
#  iam_instance_profile   = aws_iam_instance_profile.gpu-sandbox.name
#
#  tags = {
#    Name = "gpu-sandbox"
#    Label = "gpu"
#  }
#  
#  user_data = <<EOF
##! /bin/bash
##
## Install and configure git
##
#sudo git config --global credential.helper store
#sudo curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.rpm.sh | sudo bash
#sudo yum install git-lfs -y
#
##
## Setup python and pip packages
##
#su ec2-user
#git clone https://github.com/erfangc/hf-experiments.git /home/ec2-user/hf-experiments
#cd /home/ec2-user/hf-experiments
#pip3 install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu113
#pip3 install -r requirements.txt
#EOF
#  
#}
#
#
#resource "aws_iam_instance_profile" "gpu-sandbox" {
#  name = "gpu-sandbox-instance-profile"
#  role = aws_iam_role.gpu-sandbox-role.name
#}
#
#
#resource "aws_security_group" "gpu-sandbox" {
#  name        = "gpu-sandbox"
#  description = "GPU sandbox security group"
#  vpc_id      = module.vpc.vpc_id
#}
#
#resource "aws_security_group_rule" "gpu-sandbox-ssh-ingress" {
#  type              = "ingress"
#  from_port         = 22
#  to_port           = 22
#  protocol          = "tcp"
#  security_group_id = aws_security_group.gpu-sandbox.id
#  cidr_blocks       = ["0.0.0.0/0"]
#}
#
#resource "aws_security_group_rule" "gpu-sandbox-https-ingress" {
#  type              = "ingress"
#  from_port         = 443
#  to_port           = 443
#  protocol          = "tcp"
#  security_group_id = aws_security_group.gpu-sandbox.id
#  cidr_blocks       = ["0.0.0.0/0"]
#}
#
#resource "aws_security_group_rule" "gpu-sandbox-http-ingress" {
#  type              = "ingress"
#  from_port         = 80
#  to_port           = 80
#  protocol          = "tcp"
#  security_group_id = aws_security_group.gpu-sandbox.id
#  cidr_blocks       = ["0.0.0.0/0"]
#}
#
#resource "aws_security_group_rule" "gpu-sandbox-https-egress" {
#  type              = "egress"
#  from_port         = 443
#  to_port           = 443
#  protocol          = "tcp"
#  security_group_id = aws_security_group.gpu-sandbox.id
#  cidr_blocks       = ["0.0.0.0/0"]
#}
#
#resource "aws_security_group_rule" "gpu-sandbox-postgres-egress" {
#  type              = "egress"
#  from_port         = 5432
#  to_port           = 5432
#  protocol          = "tcp"
#  security_group_id = aws_security_group.gpu-sandbox.id
#  cidr_blocks       = ["0.0.0.0/0"]
#}
#
#resource "aws_iam_role" "gpu-sandbox-role" {
#  name               = "gpu_sandbox_role"
#  path               = "/"
#  assume_role_policy = jsonencode({
#    Version   = "2012-10-17",
#    Statement = [
#      {
#        Effect    = "Allow",
#        Principal = {
#          Service = "ec2.amazonaws.com"
#        },
#        Action = "sts:AssumeRole"
#      }
#    ]
#  })
#}
#
#resource "aws_iam_policy_attachment" "gpu-sandbox-policy-attachment" {
#  name       = "gpu-sandbox-policy-attachment"
#  policy_arn = aws_iam_policy.gpu-sandbox-policy.arn
#  roles      = [aws_iam_role.gpu-sandbox-role.id]
#}
#
#resource "aws_iam_policy" "gpu-sandbox-policy" {
#  name   = "gpu-sandbox-policy"
#  policy = jsonencode({
#    Version   = "2012-10-17",
#    Statement = [
#      {
#        Effect = "Allow",
#        Action = [
#          "s3:*",
#          "s3-object-lambda:*"
#        ],
#        Resource = "*"
#      }
#    ]
#  })
#}