provider "aws" {
  region = "${var.aws_region}"
}
module "staging_environment_blue" {
  source = "../modules/bluegreen"
  aws_region = "${var.aws_region}"
  version = "${var.image_version}"
  environment = "staging"
  deployment = "1"
}
module "staging_environment_green" {
  source = "../modules/bluegreen"
  aws_region = "${var.aws_region}"
  version = "${var.image_version}"
  environment = "staging"
  deployment = "2"
}
