resource "aws_instance" "jumpbox" {
  ami                  = "ami-0c614dee691cbbf37"
  instance_type        = "t2.micro"
  subnet_id            = var.subnet_id
  security_groups      = [var.jumpbox_sg_id]
  iam_instance_profile = aws_iam_instance_profile.ec2_ssm_profile.name

  user_data = <<-EOF
            #!/bin/bash
            yum update -y
            yum install -y postgresql
            EOF

  tags = merge({
    Name = "Jumpbox"
  }, local.tags)
}
