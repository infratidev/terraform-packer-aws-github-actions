locals {
  ingress_rules_packer = [{
      name        = "SSH"
      port        = 22
      description = "Ingress rules for port 22"
  }]
}

#############################################
# SG Packer:
#############################################

resource "aws_security_group" "sgpacker" {

  name        = "SGPacker"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.packer_vpc.id
  egress = [
    {
      description      = "for all outgoing traffics"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  dynamic "ingress" {
    for_each = local.ingress_rules_packer

    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  tags = {
    Name = "AWS security group dynamic block"
  }

}