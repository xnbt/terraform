resource "aws_key_pair" "publickey" {
  key_name = "hoangdl-publickey"
  public_key = file("${path.module}/publickey")
}