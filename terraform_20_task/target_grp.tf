# target group
resource "aws_lb_target_group" "target-group" {
  name        = "nit-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = "vpc-01abf249d39b75f32"

  health_check {
    enabled             = true
    interval            = 10
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}
~                                                                                                                                                                                                          
~                                                                                                                                                                                                          
~        
