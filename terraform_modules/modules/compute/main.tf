data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_launch_template" "app_template" {
  name_prefix   = "app-launch-template-"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = null

  vpc_security_group_ids = [var.app_sg_id]

  user_data = base64encode(<<-EOF
    #!/bin/bash
    apt update -y && apt upgrade -y
    apt install apache2 mysql-server php libapache2-mod-php php-mysql unzip wget curl -y
    systemctl enable apache2 && systemctl start apache2
    systemctl enable mysql && systemctl start mysql
    echo "<?php phpinfo(); ?>" > /var/www/html/index.php
  EOF
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "app_asg" {
  name                      = "app-asg"
  desired_capacity          = var.asg_desired_capacity
  max_size                  = var.asg_max_size
  min_size                  = var.asg_min_size
  vpc_zone_identifier       = var.private_subnet_ids
  health_check_type         = "EC2"
  health_check_grace_period = 300
  target_group_arns = var.target_group_arn != null ? [var.target_group_arn] : []


  launch_template {
    id      = aws_launch_template.app_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "App-Instance"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
