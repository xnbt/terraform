
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_security_group" "hoangdl-sg" {
  name        = var.sg-name
  description = "Inbound traffic"
  vpc_id      = aws_default_vpc.default.id

}

resource "aws_security_group_rule" "HTTP-traffic" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.hoangdl-sg.id
}

resource "aws_security_group_rule" "SSH-traffic" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.hoangdl-sg.id
}

resource "aws_security_group_rule" "allow_all" {
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  from_port         = 0
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.hoangdl-sg.id
}

output "sg-id" {
  value = aws_security_group.hoangdl-sg.id
}
output "vpc-id" {
  value = aws_default_vpc.default.id
}