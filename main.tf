provider "aws" {
  region = "${var.region}"
}

resource "aws_instance" "ptfe" {
  ami           = "${lookup(var.ami, var.region)}"
  instance_type = "${var.instance_type}"
  key_name      = "${aws_key_pair.ptfe_key_pair.key_name}"

  # user_data                   = "${file("ptfe_bootstrap.sh")}"

  vpc_security_group_ids = [
    "${aws_security_group.ptfe_sg.id}",
  ]
  tags {
    Name  = "${var.tag_name}"
    owner = "${var.tag_owner}"
    TTL   = "${var.tag_ttl}"
  }
  connection {
    user        = "ec2_user"
    private_key = "${file(var.key_path)}"
    agent       = false
  }
}

resource "aws_eip" "ptfe" {
  instance = "${aws_instance.ptfe.id}"
}

resource "aws_key_pair" "ptfe_key_pair" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

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
