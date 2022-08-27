variable "access_key" {
  type    = string
  default = ""
}

variable "secret_key" {
  type    = string
  default = ""
}

data "amazon-ami" "infrati-packer-ami" {
  access_key = "${var.access_key}"
  filters = {
    name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20220609"
    root-device-type    = "ebs"
    virtualization-type = "hvm"
  }
  most_recent = true
  owners      = ["099720109477"]
  region      = "us-east-1"
  secret_key  = "${var.secret_key}"
}

# "timestamp" template function replacement
locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "amazon-ebs" "infrati-packer-ami" {
  access_key    = "${var.access_key}"
  ami_name      = "packer-base-ubuntu-jammy-${local.timestamp}"
  instance_type = "t2.micro"
  region        = "us-east-1"
  secret_key    = "${var.secret_key}"
  source_ami    = "${data.amazon-ami.infrati-packer-ami.id}"
  ssh_username  = "ubuntu"
  subnet_id     = "subnet-0e83a20aaeac97eff"
  vpc_id        = "vpc-078a2fb5b28e6d923"
}

build {
  sources = ["source.amazon-ebs.infrati-packer-ami"]

  provisioner "shell" {
    inline = ["cloud-init status --wait", "sudo apt-get update && sudo apt-get upgrade -y"]
  }

  provisioner "shell" {
    scripts = ["userdata.sh"]
  }

  provisioner "shell" {
    inline = ["sudo rm -rf /var/log/ubuntu-advantage.log", "sudo truncate -s 0 /etc/machine-id", "sudo truncate -s 0 /var/lib/dbus/machine-id"]
  }

  post-processor "manifest" {
    output = "packer_manifest.json"
  }
}
