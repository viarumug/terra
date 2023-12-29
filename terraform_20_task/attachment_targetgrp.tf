
resource "aws_lb_target_group_attachment" "ec2_attach" {
  target_group_arn = aws_lb_target_group.target-group.arn
  target_id        = "i-04d85fea2891e7e64"
}

