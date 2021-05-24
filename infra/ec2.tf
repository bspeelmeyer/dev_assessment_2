resource "aws_key_pair" "deployer" {
  key_name   = "rmit-assignment-2-key"
  public_key = var.public_key
}

resource "aws_security_group" "allow_http_ssh" {
  description = "Allow inbound http and ssh traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "ssh from internet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "http from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "http from internet"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_http_ssh"
  }
}

resource "aws_instance" "server" {
  ami                    = data.aws_ami.latest_version_amazon_linux.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private_az1.id
  vpc_security_group_ids = [aws_security_group.allow_http_ssh.id]
  key_name               = aws_key_pair.deployer.key_name
}

resource "aws_lb_target_group" "todo_app" {
  name     = "todo-app-target-group"
  port     = 5000
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_target_group_attachment" "attach_instance_to_target_group" {
  target_group_arn = aws_lb_target_group.todo_app.arn
  target_id        = aws_instance.server.id
  port             = 5000
}

resource "aws_lb" "todo_app" {
  name               = "todo-app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_http_ssh.id]
  subnets            = [aws_subnet.public_az1.id, aws_subnet.public_az2.id, aws_subnet.public_az3.id]
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.todo_app.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.todo_app.arn
  }
}

