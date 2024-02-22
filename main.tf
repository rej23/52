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
        "sudo docker-compose up -d",
        "sudo apt-get install -y squid",
        "sudo cp /etc/squid/squid.conf /etc/squid/squid.conf.original", // Backup the original configuration file
        "sudo chmod a-w /etc/squid/squid.conf.original", // Protect the original file from writing
        "sudo bash -c 'echo \"http_port 3128\" >> /etc/squid/squid.conf'", // Set the HTTP port to listen through the squid proxy
        "sudo bash -c 'echo \"acl localnet src 0.0.0.1/32\" >> /etc/squid/squid.conf'", // Add an ACL for localnet TO SPECIFY DIFFERENT IP/INSTANCES THAT CAN ACCESS THE SQUID PROXY
        "sudo bash -c 'echo \"http_access allow localnet\" >> /etc/squid/squid.conf'", // Allow access to localnet
        "sudo systemctl restart squid", // Restart Squid to apply the changes
      
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
