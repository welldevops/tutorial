provider "aws" {
  region = "${var.aws_region}"
}
module "staging_environment_blue" {
  source = "../modules/bluegreen"
  aws_region = "${var.aws_region}"
  release = "${var.image_release_1}"
  environment = "prod"
  deployment = "1"
}
module "staging_environment_green" {
  source = "../modules/bluegreen"
  aws_region = "${var.aws_region}"
  release = "${var.image_release_2}"
  environment = "prod"
  deployment = "2"
}
