#create most recent amazon linux image
data "aws_ami" "ami_amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

#create ec2
resource "aws_instance" "web_ec2" {
  ami             = data.aws_ami.ami_amazon_linux.id
  instance_type   = var.taille_ec2
  key_name        = var.key_name
  security_groups = [aws_security_group.amandine-sg.name]
  tags = var.ec2_tag

  #provisioner remote(distant):install and start nginx after creating our vm
  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras install -y nginx1.12",
      "sudo systemctl start nginx",
    ]
  }

  #provisioner local: availibity zone
  provisioner "local-exec" {
    command = "echo ${aws_instance.web_ec2.id} >> infos_ec2.txt"
  }

  provisioner "local-exec" {
    command = "echo ${aws_instance.web_ec2.availability_zone} >> infos_ec2.txt"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(var.key_path)
    host        = self.public_ip
    timeout     = "30s"
  }

  root_block_device {
    delete_on_termination = true
  }
}

resource "aws_eip" "lb" {
  #instance = aws_instance.web_ec2.id
  vpc = true
  #provisioner local: get ip
  provisioner "local-exec" {
    command = "echo ${aws_instance.web_ec2.public_ip} >> infos_ec2.txt"
  }
  tags = var.ec2_tag
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.web_ec2.id
  allocation_id = aws_eip.lb.id
}

#the security group
resource "aws_security_group" "amandine-sg" {
  name        = var.sg_name

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #for ssh connexion
  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = var.sg_tag
}
