resource "aws_instance" "web_a" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_a.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]  

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install httpd -y
              echo "Instance: VM A" > /var/www/html/index.html
              systemctl start httpd
              systemctl enable httpd
              EOF

  tags = {
    Name = "web-instance-a"
  }
}

resource "aws_instance" "web_b" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_b.id
  vpc_security_group_ids = [aws_security_group.web_sg.id] 

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install httpd -y
              echo "Instance: VM B" > /var/www/html/index.html
              systemctl start httpd
              systemctl enable httpd
              EOF

  tags = {
    Name = "web-instance-b"
  }
}

