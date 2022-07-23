#!/bin/bash
yum update -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
amazon-linux-extras install java-openjdk11 -y
yum install git -y
amazon-linux-extras enable ansible2
yum install -y ansible