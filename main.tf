provider "aws" {
  region = "us-east-1"
}

variable "PRIVATE_KEY" {
  description = "My secret variable"
  default = ""
}

data "aws_ssm_parameter" "example" {
  name = "PRIVATE_KEY"
}

resource "aws_instance" "example" {

  ami           = "ami-0c7217cdde317cfec"
  instance_type = "t2.micro"
  key_name      = "firstkey"
  # other instance configurations
  vpc_security_group_ids = ["sg-0a82a67de4707a7e5"]
  tags = {
    Name = "olo"
  }

     connection {
     type        = "ssh"
     user        = "ubuntu"
     private_key = data.aws_ssm_parameter.example.value
     # private_key = filebase64(${{ secrets.PRIVATE_KEY }})
     # private_key = var.PRIVATE_KEY
     # private_key = file("${path.module}/hello.txt")
     host        = self.public_ip
   }

    provisioner "remote-exec" {
      inline = [
        "sudo  apt-get update -y",
        "sudo apt install docker.io -y",
        "sudo snap install docker",
        "sudo apt install docker-compose -y",
        "git clone https://github.com/rej23/52.git",
        "cd 52",
        "sudo docker-compose up -d"
      
      ]
    }
}

# just 9 free
# provisioner "remote-exec" {
#       inline = [
#         "sudo  apt-get update -y",
#         "sudo apt install docker.io -y",
#         "sudo snap install docker",
#         "sudo apt install docker-compose -y",
#         "git clone https://github.com/rej23/52.git",
#         "cd 52",
#         "sudo docker-compose up -d"
      
#       ]
#     }
