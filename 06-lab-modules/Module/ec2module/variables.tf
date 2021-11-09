variable "taille_ec2" {
  default = "t2.nano"
}

variable "ec2_tag" {
  type = map(any)
  default = {
    Name = "ec2_amandine"
  }
}

variable "sg_name" {
  default = "sg_amandine"
}

variable "sg_tag" {
  type = map(any)
  default = {
    Name = "sg_amandine"
  }
}

variable "key_name" {
  type = string
}

variable "key_path" {
  type = string
}