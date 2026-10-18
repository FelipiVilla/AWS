variable "my_ips" {
  type = list(string)
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

resource "aws_security_group" "web" {
  name        = "javadeploy-sg"
  description = "SSH dos IPs do campus, HTTP 8080 de qualquer lugar"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.my_ips
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
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

resource "aws_instance" "web" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.small"
  key_name               = "vockey"
  vpc_security_group_ids = [aws_security_group.web.id]
  tags                   = { Name = "javadeploy" }

  user_data = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y git ansible openjdk-21-jdk-headless
  EOF

  lifecycle {
    ignore_changes = [ami]
  }
}

output "ssh_command" {
  value = "ssh -i labsuser.pem ubuntu@${aws_instance.web.public_ip}"
}

output "app_url" {
  value = "http://${aws_instance.web.public_ip}:8080"
}