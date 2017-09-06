#create load balancer and autoscaling group of QA environment
data "aws_vpc" "pipeline" {
   tags {
       Name = "pipeline_1_vpc"
    }
}
data "aws_subnet_ids" "all" {
  vpc_id = "${data.aws_vpc.pipeline.id}"
}
data "aws_ami" "deployment_image" {
    most_recent = true
    filter {
      name = "tag:release"
      values = ["${var.release}"]
    }
    owners = ["self"]
}

data "aws_security_group" "asg" {
  name = "pipeline-1-security-group-ec2"
}
data "aws_security_group" "elb" {
  name = "pipeline-1-security-group-elb"
}

resource "aws_launch_configuration" "pipeline_1_launch_config" {
  # name          = "pipeline1-launch-config-${var.environment}-${var.deployment}"
  image_id      = "${data.aws_ami.deployment_image.image_id}"
  instance_type = "${var.instance_type}"

  # Security group
  security_groups = ["${data.aws_security_group.asg.id}"]
  user_data       = "${file("../files/userdata.sh")}"
  key_name        = "pipeline-key"
  lifecycle {
      create_before_destroy = true
  }
}

resource "aws_elb" "pipeline_1_elb" {
  name = "pipeline-1-elb-${var.environment}-${var.deployment}"

  # The same availability zone as our instance
  subnets = ["${data.aws_subnet_ids.all.ids}"]


  security_groups = ["${data.aws_security_group.elb.id}"]

  listener {
    instance_port     = 3000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:3000"
    interval            = 30
  }

  # The instance is registered automatically
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
  tags {
     Name = "pipeline-1-elb-${var.environment}-${var.deployment}"
     Env  = "${var.environment}-${var.deployment}"
 }
}


resource "aws_autoscaling_group" "pipeline_1_asg" {
  name                 = "pipeline-1-asg-${aws_launch_configuration.pipeline_1_launch_config.name}"
  max_size             = "${var.asg_max}"
  min_size             = "${var.asg_min}"
  desired_capacity     = "${var.asg_desired}"
  min_elb_capacity     = "${var.asg_min}"

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

#create route53 record for the environment
data "aws_route53_zone" "main" {
  name         = "${var.zone_name}"
}
resource "aws_route53_record" "env" {
  zone_id = "${data.aws_route53_zone.main.zone_id}"
  name    = "${var.environment}${var.deployment}.${data.aws_route53_zone.main.name}"
  type    = "A"
  alias {
    name = "${aws_elb.pipeline_1_elb.dns_name}"
    zone_id = "${aws_elb.pipeline_1_elb.zone_id }"
    evaluate_target_health = "false"
  }
}
