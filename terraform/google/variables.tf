variable "gcp_region" {}

variable "gcp_zone" {}

variable "gcp_credentials_file" {}

variable "gcp_project" {}

variable "gcp_image_user" {}

variable "gcp_image" {
  default = "rhel-cloud/rhel-7"
}

variable "gcp_machine_type" {
  default = "n1-standard-2"
}

variable "dev_channel" {
  default = "acceptance"
}

variable "prod_channel" {
  default = "production"
}

variable "hab_origin" {}
