resource "random_shuffle" "subnets" {
  input        = var.subnets
  result_count = 1
}

resource "aws_instance" "ec2" {
  ami           = var.instance_ami
  instance_type = var.instance_size
  # instance_count = var.instance_count
  iam_instance_profile = var.iam_instance_profile
  key_name             = var.key_name
  user_data            = var.user_data

  root_block_device {
    volume_size = var.instance_root_device_size
    volume_type = "gp3"
  }

  subnet_id              = random_shuffle.subnets.result[0]
  vpc_security_group_ids = var.security_groups

  # Prevents Terraform from destroying or replacing this resource - a great safety mechanism
  # lifecycle {
  #   create_before_destroy = true
  # }

  tags = merge(
    {
    },
    var.tags
  )
}

resource "aws_eip" "addr" {
  count = (var.create_eip) ? 1 : 0
  # We're not doing this directly
  # instance = aws_instance.ec2.id
  vpc = true

  # Prevents Terraform from destroying or replacing this resource - a great safety mechanism
  # lifecycle {
  #   prevent_destroy = true
  # }

  tags = {
  }
}

resource "aws_eip_association" "eip_assoc" {
  count = (var.create_eip) ? 1 : 0

  instance_id   = aws_instance.ec2.id
  allocation_id = aws_eip.addr[0].id
}