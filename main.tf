resource "aws_instance" "sonarqube" {
  ami           = data.aws_ami.joindevops.id
  instance_type = "t3.large"
  vpc_security_group_ids = [aws_security_group.sonarqube.id]
  tags = {
    Name = "sonarqube"
  }
 
  root_block_device{
    volume_size = 50
    volume_type = "gp3"
  }
  
  user_data = file("sonar.sh")
}


resource "aws_security_group" "sonarqube" {
  name        = "allow_all_sonarqube"
  description = "Allow all inbound traffic and all outbound traffic"
  vpc_id      = data.aws_vpc.default.id
  
  tags = {
    Name = "allow_all_sonarqube"
  }

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}


resource "aws_route53_record" "sonarqube" {
  zone_id = var.zone_id
  name    = "sonarqube.${var.domain_name}"
  type    = "A"
  ttl     = 1
  records = [aws_instance.sonarqube.public_ip]
  allow_overwrite = true
}

