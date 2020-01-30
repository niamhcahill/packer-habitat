provider "aws" {
  region                  = "${var.aws_region}"
  profile                 = "${var.aws_profile}"
  shared_credentials_file = "~/.aws/credentials"
}

resource "random_id" "instance_id" {
  byte_length = 4
}

////////////////////////////////
// Instance Data

data "aws_ami" "centos7" {
  most_recent = true

  filter {
    name   = "name"
    values = ["centos_7_*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["496323866215"]
}

data "aws_ami" "windows2016" {
  most_recent = true

  filter {
    name   = "name"
    values = ["windows_2016_*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["496323866215"]
}

data "aws_ami" "amazon" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-2018.*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"]
}
