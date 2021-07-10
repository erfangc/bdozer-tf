resource "aws_lb" "lb" {
  name               = "web-server-lb"
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
    fixed-response {
      content_type = "application/json"
      message_body = "{\"message\": \"Not Found\"}"
      status_code  = "404"
    }
  }
}

output "lb_dns_name" {
  value = aws_lb.lb.dns_name
}
