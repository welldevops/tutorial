provider "aws" {
  region = "${var.aws_region}"
}
module "qa_environment_blue" {
  source = "../modules/bluegreen"
  aws_region = "${var.aws_region}"
  version = "${var.image_version}"
  environment = "qa"
  deployment = "1"
}
