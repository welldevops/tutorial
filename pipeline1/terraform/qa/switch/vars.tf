variable "aws_region"{
 default="us-west-2"
}
variable "zone_name" {
   description = "zone name for our DNS"
   default     =  "opencoinproject.com."
}
variable site {
   description = "site to switch to"
}
variable environment {
   default = "qa"
}
