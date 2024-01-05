# Using Data Source to get all Avalablility Zones in Region
data "aws_availability_zones" "available_zones" {}

# Fetching Ubuntu 20.04 AMI ID
data "aws_ami" "amazon_linux_2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

# Create Launch Template for Game Nodes
resource "aws_launch_template" "game-custom-launch-template" {
  name                    = "${var.project_name}-game-config"
  image_id                = data.aws_ami.amazon_linux_2.id
  instance_type           = var.game_instance_type
  vpc_security_group_ids  = [var.alb_security_group]
  key_name                = var.key_name
  user_data               = filebase64("./game.sh")
  update_default_version  = true
  disable_api_termination = true

  monitoring {
    enabled = true
  }

  iam_instance_profile {
    name = var.instance_profile
  }
}

# Create Auto Scalling group for Game Nodes
resource "aws_autoscaling_group" "game-custom-autoscaling-group" {
  name                = "${var.project_name}-game-auto-scalling-group"
  vpc_zone_identifier = [var.public_subnet_az1_id, var.public_subnet_az2_id, var.public_subnet_az3_id]
  launch_template {
    id      = aws_launch_template.game-custom-launch-template.id
    version = aws_launch_template.game-custom-launch-template.latest_version
  }
  max_size          = var.game_desired_capacity
  min_size          = var.game_desired_capacity
  desired_capacity  = var.game_desired_capacity
  target_group_arns = [var.target_group_arn]

  tag {
    key                 = var.env
    value               = var.type
    propagate_at_launch = true
  }
  tag {
    key                 = "Name"
    value               = "Game node"
    propagate_at_launch = true
  }
}

# Fetching Game Nodes
data "aws_instances" "game_instance" {
  filter {
    name   = "tag:Name"
    values = ["Game node"]
  }

  filter {
    name   = "availability-zone"
    values = [data.aws_availability_zones.available_zones.names[0]]
  }

  filter {
    name   = "instance-state-name"
    values = ["running", "pending"]
  }
  depends_on = [aws_autoscaling_group.game-custom-autoscaling-group]
}


# Create volume for Game Nodes
resource "aws_ebs_volume" "game-volume" {
  availability_zone = data.aws_availability_zones.available_zones.names[0]
  size              = var.game_volume_size
  type              = "gp2"
  tags = {
    Snapshot = "true"
    Name     = "Game Volume"
  }
}
