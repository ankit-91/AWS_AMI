# Define Packer template
packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

# Define the source (AWS)
source "amazon-ebs" "ubuntu-ami" {
  ami_name      = "packer-ubuntu-ami-{{timestamp}}"
  instance_type = "t2.micro"
  region        = "us-east-1"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    owners      = ["099720109477"] # Canonical (Ubuntu) owner ID
    most_recent = true
  }
  ssh_username = "ubuntu"
}

# Provisioner to customize the instance
build {
  sources = ["source.amazon-ebs.ubuntu-ami"]

  provisioner "shell" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y nginx",
      "echo 'Hello from Packer!' > /var/www/html/index.html"
    ]
  }
}
