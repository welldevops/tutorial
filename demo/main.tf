provider "aws"{
  region = "us-west-2"
}
resource "aws_instance" "test" {
  ami           = "ami-6df1e514"
  instance_type = "t2.medium"
  subnet_id     = "subnet-502aef18"
  vpc_security_group_ids  = ["sg-aae2ebd0"]
  key_name = "pipeline-key"

  # Copies the myapp.conf file to /etc/myapp.conf
  provisioner "file" {
    source      = "./server.conf"
    destination = "/tmp/server.conf"
    connection  =  {
         user = "ec2-user"
         private_key = "${ file("~/.ssh/id_rsa") }"
    }
  }
}
