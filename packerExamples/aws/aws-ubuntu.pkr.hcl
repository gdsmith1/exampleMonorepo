packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "gibson-packer-linux-aws-2"
  instance_type = "t2.micro"
  region        = "us-east-1"
  source_ami_filter {
    filters = {
      name                = "amzn2-ami-hvm-*-x86_64-ebs"  # This targets Amazon Linux 2 AMIs
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["137112412989"]  # This is the AWS account ID for Amazon Linux AMIs
  }
  ssh_username = "ec2-user"
  
  vpc_id     = "vpc-099f86fc1727f5e0b"
  subnet_id  = "subnet-0089077f23e5dd43d"
  security_group_id = "sg-0959a79345cf4dbbf"
  associate_public_ip_address = true
}

build {
  name = "learn-packer-gibson"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]
  provisioner "shell" {
  inline = [
    "sudo yum update -y && sudo yum upgrade -y",
    "sudo yum install -y java git",
    "git clone https://github.com/liatrio/spring-petclinic.git",
    "cd spring-petclinic",
    "export HOME=$(pwd)",
    "./mvnw package"#,
    #"nohup java -jar target/*.jar &"
  ]
  }

}
