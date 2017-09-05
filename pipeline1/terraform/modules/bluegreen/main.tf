#create load balancer and autoscaling group of QA environment

data "aws_availability_zones" "all" {

}
data "aws_subnet_ids" "all" {
  vpc_id = "${var.vpc_id}"
}



resource "aws_launch_configuration" "pipeline_1_launch_config" {
  # name          = "pipeline-1-launch-config-${var.environment}-${var.deployment}"
  image_id      = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type = "${var.instance_type}"

  # Security group
  security_groups = ["${var.asg_secgroup}"]
  user_data       = "${file("files/userdata.sh")}"
  key_name        = "pipeline-key"
  lifecycle {
      create_before_destroy = true
  }
}

resource "aws_elb" "pipeline_1_elb" {
  name = "pipeline-1-elb-${var.environment}-${var.deployment}"

  # The same availability zone as our instance
  subnets = ["${data.aws_subnet_ids.all.ids}"]


  security_groups = ["${var.elb_secgroup}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 10
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  # The instance is registered automatically
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
  tags {
     Name = "pipeline-1-elb-${var.environment}-${var.deployment}"
 }
}


resource "aws_autoscaling_group" "pipeline_1_asg" {
  name                 = "pipeline-1-asg-${var.environment}-${var.deployment}"
  max_size             = "${var.asg_max}"
  min_size             = "${var.asg_min}"
  desired_capacity     = "${var.asg_desired}"
  force_delete         = true
  launch_configuration = "${aws_launch_configuration.pipeline_1_launch_config.name}"
  load_balancers       = ["${aws_elb.pipeline_1_elb.name}"]

  vpc_zone_identifier  = ["${data.aws_subnet_ids.all.ids}"]
  tag {
    key                 = "Name"
    value               = "pipeline-1-asg-${var.environment}-${var.deployment}"
    propagate_at_launch = "true"
  }
  tag {
    key                 = "Env"
    value               = "${var.environment}"
    propagate_at_launch = "true"
  }
}
