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

output "lb_dns_name" {
  value = aws_lb.lb.dns_name
}

#################
# test out NLBs #
#################
resource "aws_lb_target_group" "nlb-tg" {
  name     = "nlb-tg"
  port     = 80
  protocol = "TCP"
  vpc_id   = module.vpc.vpc_id
}

resource "aws_lb" "nlb" {
  name               = "test-nlb"
  internal           = false
  load_balancer_type = "network"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = module.vpc.public_subnets
}

resource "aws_lb_listener" "nlb-listener" {
  load_balancer_arn = aws_lb.front_end.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb-tg.arn
  }
}
