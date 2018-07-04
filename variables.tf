# variable access_key {
#   description = "please enter your AWS access key"
# }

# variable secret_key {
#   description = "please enter your AWS secret key"
# }

variable "region" {
  description = "please enter the AWS region."
  default     = "eu-west-2"
}

variable "ami" {
  type        = "map"
  description = "A map of AMIs"

  default = {
    eu-west-2 = "ami-6b3fd60c"
  }
}

variable "instance_type" {
  description = "The instance type to launch."
  default     = "t2.xlarge"
}

variable "tag_name" {
  description = "the Value you want to appear in the Name Tag"
  default     = "My Demo Instance - Guy Barros"
}

variable "tag_owner" {
  description = "the Value you want to appear in the Owner Tag"
  default     = "guy@hashicorp.com"
}

variable "tag_ttl" {
  description = "the Value you want to appear in the Name ttl"
  default     = 48
}

variable "key_name" {
  description = "please enter  the AWS key pair to use for resources."
  default     = "ptfe default ssh key"
}

variable "public_key_path" {
  description = "please enter your public ssh key path"
}

variable "private_key_path" {
  description = "please enter your private ssh key path"
}

variable "volume_size" {
  description = "the Value you want for your ec2 volume"
  default     = 100
}

variable "host_user" {
  description = "the username you want to use for ssh"
  default     = "ubuntu"
}
