provider "aws" {
  region = "us-east-1"
}


locals {
  key_name        = "~/Downloads/1005.pem"
}

resource "aws_security_group" "ec2_security_group" {
  name_prefix = "ec2-sg-wp"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8000
    to_port   = 8000
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Add more ingress rules if needed

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "ec2_instance" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  key_name       = local.key_name

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y docker.io",
      "sudo apt-get install -y docker-compose",
      "sudo usermod -aG docker ubuntu",
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "git clone https://github.com/Davidoh11/terrafrom_class12.git",
      "cd your-repo",
      "docker-compose up -d",
    ]
  }

}

output "instance_public_ip" {
  value = aws_instance.ec2_instance.public_ip
}


