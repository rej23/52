provider "aws" {
  region = "us-east-1"
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
     private_key = ${{ secrets.key }}
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
