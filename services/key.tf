resource "aws_key_pair" "prod-publickey" {
  key_name = "hoangdl-prod-publickey"
  public_key = file("${path.module}/prod-publickey")
}