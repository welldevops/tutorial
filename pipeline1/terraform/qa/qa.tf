provider "aws" {
  region = "${var.aws_region}"
}
module "qa_environment_blue" {
  source = "../modules/bluegreen"
  aws_region = "${var.aws_region}"
  release = "${var.image_release}"
  environment = "qa"
  deployment = "1"
}
