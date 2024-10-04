terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}


provider "aws" {
  region     = "us-east-1"
}

resource "aws_instance" "gh-runner" {
  ami           = "ami-0866a3c8686eaeeba" # Ubuntu 24.04
  instance_type = "t2.micro"
  subnet_id     = "subnet-0391ff85858065967" #default-subnet-public1-us-east-1a
  key_name      = "gibson-key"
  associate_public_ip_address = true

  tags = {
    Name = "GibsonActionRunner"
  }

  provisioner "local-exec" {
   command = <<EOT
     ansible-playbook -i '${self.public_ip},' -u ubuntu --private-key ./gibson-key.pem ./playbook.yml
   EOT

 }


}


output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.gh-runner.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.gh-runner.public_ip
}
