resource "aws_lb" "lb" {
  name               = "ecs-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = module.vpc.public_subnets
}

resource "aws_lb_listener" "lb-listener" {
  load_balancer_arn = aws_lb.lb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "application/json"
      message_body = "{\"message\": \"Not Found\"}"
      status_code  = "404"
    }
  }
}

resource "aws_vpc_endpoint_service" "vpces" {
  acceptance_required        = false
  network_load_balancer_arns = [aws_lb.lb.arn]
  private_dns_name           = "api-services"
}

output "lb_dns_name" {
  value = aws_lb.lb.dns_name
}
