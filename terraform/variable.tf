variable "s3_bucket_name" {
  default = "ansible-3-tier-tf-state-bucket-piyush"
}

variable "Project_name" {
  default = "ansible-3-tier"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "pub_cidr" {
  default = "10.0.16.0/20"
}

variable "pvt_cidr" {
  default = "10.0.0.0/20"
}

variable "pvt_cidr2" {
  default = "10.0.32.0/20"
}

variable "az1" {
  default = "ap-south-1a"
}

variable "az2" {
  default = "ap-south-1b"
}

variable "ami_id" {
  default = "ami-0d176f79571d18a8f"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_pair" {
  description = "Existing EC2 key pair name"
  default = "my-ansible"
}

# RDS Variables
variable "db_name" {
  default = "ansible3tierdb"
}

variable "db_username" {
  default = "admin"
}

variable "db_password" {
  default = "piyush07"
}

variable "db_instance_class" {
  default = "db.t2.micro"
}
