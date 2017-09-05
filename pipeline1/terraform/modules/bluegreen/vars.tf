variable vpc_id{
   description="VPC where environment will be created"
}
variable "aws_region"{
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
variable environment {
   description = "Environment to create"
}
variable deployment {
   description=" Blue or green deployment"
}
variable asg_secgroup {
   description=" Name of the security group"
}
variable elb_secgroup {
   description=" Name of the security group"
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
