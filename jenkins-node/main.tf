resource "aws_instance" "jenkins-node" {
  ami                    = "ami-0c802847a7dd848c0"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.terraform_remote_state.networking.outputs.sg-id]
  key_name               = aws_key_pair.publickey.key_name
  user_data              = file("${path.module}/userdata.sh")

  tags = {
    Name = "hoangdl-jenkins-agent"
  }
}

data "terraform_remote_state" "networking" {
  backend = "s3"

  config = {
    bucket = var.bucket

    key    = "vpc/terraform.tfstate"
    region = "ap-southeast-1"
  }
}

data "aws_subnet_ids" "example" {
  vpc_id = data.terraform_remote_state.networking.outputs.vpc-id
}

data "aws_subnet" "hoangdl-subnet" {
  for_each = data.aws_subnet_ids.example.ids
  id       = each.value
}

output "vpc-id" {
  value = data.terraform_remote_state.networking.outputs.vpc-id
}
output "agent-ip" {
  value = aws_instance.jenkins-node.public_ip
}