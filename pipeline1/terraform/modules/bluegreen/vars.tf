variable "aws_region"{
 default="us-west-2"
}
variable "release" {
   description = "AMI version being deployed"
}
variable "zone_name" {
   description = "zone name for our DNS"
   default     =  "opencoinproject.com."
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
variable "asg_max" {
  default="3"
}
variable "asg_min" {
  default="2"
}
variable "asg_desired" {
  default="2"
}
