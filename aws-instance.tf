##############################################################
resource "aws_key_pair" "sshkey" {
  key_name   = "tkey"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDw9jnUq6N3RcqFSJdfkdqZMRz5xsgy32zd3FZgKjln0VIO9PZoerOIjRODSj7lCaEHPSRdgkrQwu+n50zdRm0kOzIb9rs3hVDzHqI/pp8BPFp9ehVsn661J/diCkWYHkrx6FV7TY1O63I8nU3TdaqYZT4XBmEM4pcBN389BG1LJxDZtuS1FtyJZcHCRd+kfhCJOHr1vbA5Mh8nvFaV9FIC+OTR9PfGAfx1cLVqWeQfYI7rUznyj00oOM7RhQeCfLj+k33omB21FcKJw48fFA6AEepsz6DUfE1Z+mZ+C/4hvYmCV3HSAfOovkfmYkEQzHQNhISNcAdbC+/s3usd3Ttp fuji@lap"
}

#################################################################
resource "aws_security_group" "webserver" {

    name         = "webserver"
    description  = "allows 80 from all"

    ingress {
        cidr_blocks = ["0.0.0.0/0"]  
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
      }
    
    ingress {
        cidr_blocks = ["0.0.0.0/0"]  
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
      }
     egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
    }

    tags = {
        Name = "webserver"
    }
}    

##########################################################################
resource "aws_security_group" "ssh" {

    name         = "ssh"
    description  = "allows 22 from all"

    ingress {
        cidr_blocks = ["0.0.0.0/0"]  
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
      }

     egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
    }

    tags = {
        Name = "ssh"
    }
}    

##########################################################################


resource "aws_instance" "webserver" {

    ami = "ami-00bf61217e296b409"
    instance_type = "t2.micro"
    key_name = "tkey"
    availability_zone  = "us-east-2a"
    associate_public_ip_address = true
    vpc_security_group_ids = ["${aws_security_group.webserver.id}",
                               "${aws_security_group.ssh.id}"]
    tags = {
        Name = "webserver"
  }
}
