locals {
  domain = "elasticsearch-domain"
}
resource "aws_elasticsearch_domain" "esd" {
  domain_name = local.domain
  elasticsearch_version = "7.10"

  cluster_config {
    instance_type = "t3.small.elasticsearch"
    zone_awareness_enabled = true
  }

  vpc_options {
    subnet_ids = module.vpc.private_subnets
    security_group_ids = [aws_security_group.elasticsearch-domain-sg.id]
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 10
  }

  access_policies = jsonencode({
    Version = "2012-10-17",
    Statement: [
      {
        Action = "es:*",
        Principal = "*",
        Effect = "Allow",
        Resource = "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${local.domain}/*"
      }
    ]
  })
}