////////////////////////////////
// AWS Connection

variable "aws_region" {
  default="us-east-1"
  description = "aws_region is the AWS region in which we will build instances"
}

variable "aws_profile" {
  default="default"
  description = "aws_profile is the profile from your credentials file which we will use to authenticate to the AWS API."
}

variable "aws_credentials_file" {
  default="~/.aws/credentials"
  description = "aws_credentials_file is the file on your local disk from which we will obtain your AWS API credentials."
}

variable "aws_key_pair_name" {
  default="habichef_demo"
  description = "aws_key_pair_naem is the AWS keypair we will configure on all newly built instances."
}

variable "aws_key_pair_file" {
  description = "aws_key_pair_file is the local SSH private key we will use to log in to AWS instances"
}

variable "aws_ami_id" {
  description = "aws_ami_id is the (optional) AWS AMI to use when building new instances if you would prefer to specify a specific AMI instead of using the latest for your platform."
  default = ""
}

variable "aws_vpc_id" {
  default=""
  description = "aws_vpc_id is the VPC within which you want to build instances"
}

variable "aws_subnet_id" {
  default=""
  description = "aws_subnet_id is the Subnet within which you want to build instances"
}


////////////////////////////////
// Object Tags

variable "tag_customer" {
  description = "tag_customer is the customer tag which will be added to AWS"
  default = "habichef_demo"
}

variable "tag_project" {
  description = "tag_project is the project tag which will be added to AWS"
  default = "habichef_demo"
}

variable "tag_name" {
  description = "tag_name is the name tag which will be added to AWS"
  default = "jcowie"
}

variable "tag_dept" {
  description = "tag_dept is the department tag which will be added to AWS"
  default = "ace"
}

variable "tag_contact" {
  description = "tag_contact is the contact tag which will be added to AWS"
  default = "success@chef.io"
}

variable "tag_application" {
  description = "tag_application is the application tag which will be added to AWS"
  default = "habichef"
}

variable "tag_ttl" {
  default = 3600
}

////////////////////////////////
// OS Variables

variable "aws_centos_image_user" {
  default = "centos"
  description = "aws_centos_image_user is the username which will be used to log in to centos instances on AWS"
}

variable "aws_ubuntu_image_user" {
  default = "ubuntu"
  description = "aws_ubuntu_image_user is the username which will be used to log in to ubuntu instances on AWS"
}

variable "platform" {
  default = "ubuntu"
  description = "platform will be used to specify the correctl home directory to be used during A2 setup"
}

variable "admin_password" {
  default = "Ch3fR0cks1234!"
  description = "admin_password is the Windows password which will be used to log in to Windows instances on AWS"
}

variable "win_instance_type" {
  default = "m4.xlarge"
  description = "Windows instance type is the aws instance to provision"
}

////////////////////////////////
// Habitat Variables

variable "habitat_dev_channel" {
  description = "habitat_dev_channel is the channel to install Habitat applications in devlopment from"
  default = "unstable"
}

variable "habitat_prod_channel" {
  description = "habitat_prod_channel is the channel to install Habitat applications in production from"
  default = "stable"
}