#resource "aws_transfer_user" "transfer-user" {
#  role      = aws_iam_role.transfer-server-role.arn
#  server_id = aws_transfer_server.transfer-server.id
#  user_name = "testuser"
#  home_directory = "/erfangchen.com/testuser"
#}
#
#resource "aws_transfer_server" "transfer-server" {
#  identity_provider_type = "SERVICE_MANAGED"
#  protocols              = ["SFTP"]
#  endpoint_type          = "VPC"
#  endpoint_details {
#    subnet_ids = module.vpc.private_subnets
#    vpc_id     = module.vpc.vpc_id
#  }
#  tags                   = {
#    name = "Default Transfer Server"
#  }
#}
#
#resource "aws_transfer_ssh_key" "ssh-key" {
#  body      = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCsUTG5XOS9WgBD+izYPhhNSdqs7MNh5wfG7areUd69fAddvYm1bNpWgB8EWwVgOnsPnChm6d+/hWkSdGe/EXfHUzLBtzJ58bq3iN/UMnAZ1NLrRbo1F629uTV0VvOx9Fw8tCe0HVu25XD1n9C4hU6HoB038JPzSolXnHmW0RBM35KIpmQwD+vjMLR4v/rn4eitfXEdN3CyxVZHWPPEh3QNn5TgwvrPWFan832lsFTAQ4Bddl32XOLSwFXgNJsPexKKjG711EdDiYJttJ0Umw8qYve/+cNOYWfN5dKXo5ij0fuGp4ElHOrrMHSY8+35j4Don5CqMIB/rhJYLB3Z2Odi7dPDsBNAigqEAhPj6LJQLPboxTTILNLyb+18+KwRI1HndPB77uA1IurbChP557kxU1htjTaVQIRdX1Cl1NWuCwzRU8vlUJNTMQBchy1pCkyxHWduhyjSHx7th3WGpU67mzTtQwtDmdhYmvPSd9EazAd0GKEqDcU5cgTZMNM5lp6CSTqgsaCiezQVCbhLSr0ZNowGAdjEZdOVqhAmz01PDUt8dqscUcvRXPr7qRQNwJ01isH64hTZYYx7j1Z7EPcAzb9swcuyi2Gr8IWPYBTiuyS4eKQR0LDJQ6TAO2xBZY0u9idvK95wnrC1PdSYVHGW2KK0O/btyYxiqTp/omMy1w== ssm-user@ip-10-10-10-49.ec2.internal"
#  server_id = aws_transfer_server.transfer-server.id
#  user_name = aws_transfer_user.transfer-user.user_name
#}
#
#resource "aws_iam_role" "transfer-server-role" {
#  name = "tf-test-transfer-user-iam-role"
#
#  assume_role_policy = <<EOF
#{
#    "Version": "2012-10-17",
#    "Statement": [
#        {
#        "Effect": "Allow",
#        "Principal": {
#            "Service": "transfer.amazonaws.com"
#        },
#        "Action": "sts:AssumeRole"
#        }
#    ]
#}
#EOF
#}
#
#resource "aws_iam_role_policy" "transfer-server-policy" {
#  name = "tf-test-transfer-user-iam-policy"
#  role = aws_iam_role.transfer-server-role.id
#
#  policy = <<POLICY
#{
#    "Version": "2012-10-17",
#    "Statement": [
#        {
#            "Sid": "AllowFullAccesstoS3",
#            "Effect": "Allow",
#            "Action": [
#                "s3:*"
#            ],
#            "Resource": "*"
#        }
#    ]
#}
#POLICY
#}
