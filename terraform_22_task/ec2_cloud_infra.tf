terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "5.31.0"
    }
  }
}

provider "aws"{
    region = "ap-south-1"
}


resource "aws_security_group" "public-sg" {
name = "public-sg"
vpc_id = "vpc-01abf249d39b75f32"
ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }
ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 80
    to_port = 80
    protocol = "tcp"
  }


  egress {
   from_port = 0
   to_port = 0
   protocol = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
tags = {
    Name = "web-app"
  }
}


resource "aws_instance" "ec2-web" {
ami           = "ami-00407a652647fc7f2" # us-west-2
instance_type = "t3.medium"
key_name = "terraform"
associate_public_ip_address = true	
subnet_id      = "subnet-03fd7ed8d2efd5ff1"
iam_instance_profile = aws_iam_instance_profile.this.name
vpc_security_group_ids = [aws_security_group.public-sg.id]
user_data = "${file("nginx.sh")}"

 
tags = {
Name = "Web-App"
  }
 }


resource "aws_cloudwatch_metric_alarm" "ec2_cpu" {
     alarm_name                = "cpu-utilization"
     comparison_operator       = "GreaterThanOrEqualToThreshold"
     evaluation_periods        = "2"
     metric_name               = "CPUUtilization"
     namespace                 = "AWS/EC2"
     period                    = "120" #seconds
     statistic                 = "Average"
     threshold                 = "5"
     alarm_description         = "This metric monitors ec2 cpu utilization"
     insufficient_data_actions = []
dimensions = {
       InstanceId = aws_instance.ec2-web.id
     }
}


locals {
  userdata = templatefile("nginx.sh", {
    ssm_cloudwatch_config = aws_ssm_parameter.cw_agent.name
  })
}


resource "aws_ssm_parameter" "cw_agent" {
  description = "Cloudwatch agent config to configure custom log"
  name        = "/cloudwatch-agent/config"
  type        = "String"
  value       = "${file("cw_agent_config.json")}"
}


locals {
  role_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMFullAccess",
    "arn:aws:iam::aws:policy/AmazonCloudWatchRUMFullAccess"
  ]
}

resource "aws_iam_instance_profile" "this" {
  name = "EC2-Profile"
  role = aws_iam_role.this.name
}

resource "aws_iam_role_policy_attachment" "this" {
  count = length(local.role_policy_arns)
  role       = aws_iam_role.this.name
  policy_arn = element(local.role_policy_arns, count.index)
}

resource "aws_iam_role_policy" "this" {
  name = "EC2-Inline-Policy"
  role = aws_iam_role.this.id
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "ssm:GetParameter"
          ],
          "Resource" : "*"
        }
      ]
    }
  )
}

resource "aws_iam_role" "this" {
  name = "EC2-Role"
  path = "/"

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : "sts:AssumeRole",
          "Principal" : {
            "Service" : "ec2.amazonaws.com"
          },
          "Effect" : "Allow"
        }
      ]
    }
  )
}

resource "aws_cloudwatch_metric_alarm" "disk_use" {
  alarm_name                = "ec2-disk-usage"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "disk_used_percent"
  namespace                 = "CWAgent"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "20"
  alarm_description         = "This metric monitors ec2 disk utilization"
  actions_enabled           = "true"
  alarm_actions             = ["arn:aws:sns:ap-south-1:065882759854:cloudwatch.fifo"]
  insufficient_data_actions = []
  #treat_missing_data = "notBreaching"

   dimensions = {
    path = "/"
    InstanceId = "i-04d85fea2891e7e64"
    device = "/dev/sda1"
    fstype = "ext4"
  }
}


resource "aws_cloudwatch_metric_alarm" "high_memory_usage" {
  alarm_name          = "high-memory-usage"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "mem_used_percent"
  namespace           = "CWAgent"
  period              = "300"
  statistic           = "Average"
  threshold           = 20
  alarm_description   = "This alarm monitors EC2 memory usage"
  alarm_actions       = ["arn:aws:sns:ap-south-1:065882759854:cloudwatch.fifo"]

  dimensions = {
    InstanceId = aws_instance.ec2-web.id
  }
}

