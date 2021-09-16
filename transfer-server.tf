resource "aws_transfer_user" "transfer-user" {
  role      = aws_iam_role.transfer-server-role.arn
  server_id = aws_transfer_server.transfer-server.id
  user_name = "testuser"
  home_directory = "/erfangchen.com/testuser"
}

resource "aws_transfer_server" "transfer-server" {
  identity_provider_type = "SERVICE_MANAGED"
  protocols              = ["SFTP"]
  endpoint_type          = "VPC"
  endpoint_details {
    subnet_ids = module.vpc.private_subnets
    vpc_id     = module.vpc.vpc_id
  }
  tags                   = {
    name = "Default Transfer Server"
  }
}

resource "aws_iam_role" "transfer-server-role" {
  name = "tf-test-transfer-user-iam-role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Principal": {
            "Service": "transfer.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "transfer-server-policy" {
  name = "tf-test-transfer-user-iam-policy"
  role = aws_iam_role.transfer-server-role.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowFullAccesstoS3",
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": "*"
        }
    ]
}
POLICY
}
