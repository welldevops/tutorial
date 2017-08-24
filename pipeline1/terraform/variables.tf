variable "aws_region"{
  description = "This is the region where our template will be provisioned"
  default= "us-west-2"
}
variable "aws_amis" {
  description = "This is the AMI to use depending on the region"
  default = {
     "us-west-2"="ami-6df1e514",
     "us-east-1"="ami-8a7859ef"
  }
}
variable "instance_type" {
   description="EC2 Instance type"
   default="t2.micro"
}
variable "asg_max" {
  default="2"
}
variable "asg_min" {
  default="1"
}
variable "asg_desired" {
  default="1"
}
