resource "aws_instance" "web" {
  ami             = var.packer_ami_id
  subnet_id       = aws_subnet.public_subnet.id
  security_groups = [aws_security_group.sg.id]
  instance_type   = var.instance_type

user_data = <<-EOF
  #!/bin/bash
  sudo echo "<h1> Welcome to my packer and terraform ==> https://infrati.dev <== WebServer IP: $(curl -s ifconfig.me) </h1>" | sudo tee "/var/www/html/index.html"
  EOF

  volume_tags = {
    Name = "web_instance"
  } 

 tags = {
    Name        = var.name
    Environment = var.env
    Provisioner = "Terraform-infratidev"
   }

}