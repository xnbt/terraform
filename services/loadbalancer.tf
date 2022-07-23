resource "aws_lb" "hoangdl-alb" {
  name               = var.alb-name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [data.terraform_remote_state.networking.outputs.sg-id]
  subnets            = [for subnet in data.aws_subnet.hoangdl-subnet : subnet.id]

}
resource "aws_lb_target_group" "ec2-tg" {
  name     = var.target-group-name
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.networking.outputs.vpc-id
}

# resource "aws_lb_target_group" "lambda-tg" {
#   name     = var.target-group-name
#   port     = 80
#   protocol = "HTTP"
#   vpc_id   = data.terraform_remote_state.networking.outputs.vpc-id
# }

resource "aws_lb_target_group_attachment" "ec2-0" {
  target_group_arn = aws_lb_target_group.ec2-tg.arn
  target_id        = aws_instance.hoangdl-amz-ec2[0].id
  port             = 80
}
resource "aws_lb_target_group_attachment" "ec2-1" {
  target_group_arn = aws_lb_target_group.ec2-tg.arn
  target_id        = aws_instance.hoangdl-amz-ec2[1].id
  port             = 80
}
# resource "aws_lb_target_group_attachment" "lambda-1" {
#   target_group_arn = aws_lb_target_group.lambda-tg.arn
#   target_id        = aws_lambda_function.test_lambda.arn
#   depends_on       = [aws_lambda_permission.with_lb]
#   port             = 80
# }


resource "aws_lb_listener" "hoangdl" {
  load_balancer_arn = aws_lb.hoangdl-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ec2-tg.arn
  }
}
# resource "aws_lb_listener" "lambda" {
#   load_balancer_arn = aws_lb.hoangdl-alb.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.lambda-tg.arn
#   }
# }

resource "aws_lb_listener_rule" "static" {
  listener_arn = aws_lb_listener.hoangdl.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ec2-tg.arn
  }

  condition {
    path_pattern {
      values = ["/test*"]
    }
  }

}
# resource "aws_lb_listener_rule" "lambda" {
#   listener_arn = aws_lb_listener.lambda.arn
#   priority     = 101

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.lambda-tg.arn
#   }

#   condition {
#     path_pattern {
#       values = ["/search*"]
#     }
#   }

# }
