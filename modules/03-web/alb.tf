resource "aws_lb" "web" {
  name               = "${local.name_prefix}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.web_lb_sg_id]
  subnets            = var.web_subnet_ids

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-lb"
  })
}




resource "aws_lb_target_group" "web" {
  name        = "${local.name_prefix}-lb-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip" // for ecs
  vpc_id      = var.vpc_id

  health_check {
    path                = "/api/healthcheck"
    protocol            = "HTTP"
    port                = var.container_port
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 60
    matcher             = "200"

  }

  stickiness {
    enabled = true
    type    = "lb_cookie"
  }

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-lb-tg"
  })
}

resource "aws_lb_listener" "web" {
  load_balancer_arn = aws_lb.web.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = aws_acm_certificate.cert.arn
  depends_on        = [aws_acm_certificate_validation.cert]

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Access Denied"
      status_code  = "403"
    }
  }

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-lb-listener"
  })
}

resource "aws_lb_listener_rule" "custom_header" {
  listener_arn = aws_lb_listener.web.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }

  condition {
    http_header {
      http_header_name = var.header_name
      values           = [var.header_value]
    }
  }

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-lb-listener-rule"
  })
}
