provider "aws" {
  region = "sa-east-1"
}
resource "aws_instance" "javammota" {
  ami                         = "ami-054a31f1b3bf90920"
  instance_type               = "t2.micro"
  subnet_id                   = "subnet-0a7ce1b942558345a"
  key_name                    = "key-mmotadev"
  associate_public_ip_address = true

  tags = {
    Name = "javammota"
  }
  root_block_device {
    volume_size           = "8"
    volume_type           = "gp2"
    encrypted             = true
    delete_on_termination = true
  }

  vpc_security_group_ids = [aws_security_group.java-sg.id]

}
resource "aws_security_group" "java-sg" {
  name = "java-sg"
  vpc_id = "vpc-0581d08eb6f432641"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
 }
#output "sucesso" {
#  value = [aws_instance.nginxmmota.public_dns]
#  value = "Maquina criada com sucesso DNS IP para acesso ${aws_instance.nginxmmota.public_dns}"
#
#  description = "IPs publicos e privados da maquina criada."
#  }
output "aws_instance_e_ssh" {
  value = aws_instance.javammota.public_dns
}
