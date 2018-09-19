provider "aws" {
  region = "${var.region}"
}

resource "aws_instance" "ptfe" {
  ami           = "${lookup(var.ami, var.region)}"
  instance_type = "${var.instance_type}"
  key_name      = "${var.key_name}"
  user_data     = "${file("./init_install.sh")}"

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_type = "gp2"
    volume_size = "${var.volume_size}"
  }

  vpc_security_group_ids = [
    "${aws_security_group.ptfe_sg.id}",
  ]

  tags {
    Name  = "PTFE"
    owner = "${var.tag_owner}"
    TTL   = "${var.tag_ttl}"
  }

  # connection {
  #   user        = "${var.host_user}"
  #   private_key = "${var.private_key}"
  #   agent       = false
  # }

  #provisioner "remote-exec" {
  #  inline = [
  #    "curl https://install.terraform.io/ptfe/stable > install_ptfe.sh",
  #    "chmod 500 install_ptfe.sh",
  #    "sudo ./install_ptfe.sh no-proxy bypass-storagedriver-warnings",
  #  ]
  #}
}

resource "aws_eip" "ptfe" {
  instance = "${aws_instance.ptfe.id}"
}

# resource "aws_key_pair" "ptfe_key_pair" {
#   key_name   = "${var.key_name}"
#   public_key = "${var.public_key}"
# }

resource "aws_security_group" "ptfe_sg" {
  name        = "ptfe_inbound"
  description = "Allow ptfe ports and ssh from Anywhere"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8200
    to_port     = 8200
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8800
    to_port     = 8800
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9870
    to_port     = 9880
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "getsecret" {
  source  = "app.terraform.io/emea-se-playground/getsecret/vault"
  version = "0.0.2"
}
  
resource "null_resource" "cluster" {
  # Changes to any instance of the cluster requires re-provisioning
       provisioner "local-exec" {
 command = "echo ${module.getsecret.mysecret}",
           
           }

}

output "please open the following url in your browser to continue install" {
  value = "http://${aws_instance.ptfe.public_dns}:8800"
}
