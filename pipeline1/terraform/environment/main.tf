#select our cloud provider
provider "aws" {
  region = "${var.aws_region}"
}

#create our vpc from scratch
resource "aws_vpc" "pipeline_1_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags {
    Name = "pipeline_1_vpc"
  }
}

#create our first subnet with cidr 10.0.0.0/24
resource "aws_subnet" "pipeline_1_vpc_subnet_1" {
  vpc_id                  = "${aws_vpc.pipeline_1_vpc.id}"
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "${var.aws_region}a"
  tags {
    Name = "pipeline_1_vpc_subnet_1"
  }
}

#create our second subnet with CIDR 10.1.0.0/24
resource "aws_subnet" "pipeline_1_vpc_subnet_2" {
  vpc_id                  = "${aws_vpc.pipeline_1_vpc.id}"
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = true
  tags {
    Name = "pipeline_1_vpc_subnet_2"
  }
}

#create internet gateway to attach to our instance
resource "aws_internet_gateway" "pipeline_1_vpc_igw" {
  vpc_id = "${aws_vpc.pipeline_1_vpc.id}"

  tags {
    Name = "pipeline_1_vpc_ig"
  }
}


#establish our route table and associate it with our subnet
resource "aws_route_table" "pipeline_1_route_table" {
  vpc_id = "${aws_vpc.pipeline_1_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.pipeline_1_vpc_igw.id}"
  }

  tags {
    Name = "pipeline_1_route_table"
  }
}
resource "aws_route_table_association" "pipeline_1_vpc_sub1_rt_assoc" {
  subnet_id      = "${aws_subnet.pipeline_1_vpc_subnet_1.id}"
  route_table_id = "${aws_route_table.pipeline_1_route_table.id}"
}
resource "aws_route_table_association" "pipeline_1_vpc_sub2_rt_assoc" {
  subnet_id      = "${aws_subnet.pipeline_1_vpc_subnet_2.id}"
  route_table_id = "${aws_route_table.pipeline_1_route_table.id}"
}

/*
 * Create a security group that only allows access to port 22 & 80
 * our instances
 */
resource "aws_security_group" "pipeline_1_security_group_ec2" {
  name        = "pipeline-1-security-group-ec2"
  description = "Only allows port 80 and 22"
  vpc_id      = "${aws_vpc.pipeline_1_vpc.id}"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from anywhere
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = ["${aws_security_group.pipeline_1_security_group_elb.id}"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

/*
 * Create a security group that only allows access to port 80
 * our instances
 */
resource "aws_security_group" "pipeline_1_security_group_elb" {
  name        = "pipeline-1-security-group-elb"
  description = "Only allows port 80 and 22"
  vpc_id      = "${aws_vpc.pipeline_1_vpc.id}"

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#create the key pair to use
resource "aws_key_pair" "pipeline_1_key_pair" {
  key_name   = "pipeline-key"
  public_key = "${file("files/public.key")}"
}

#create jenkins instance
resource "aws_instance" "web" {
  ami           = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type = "t2.medium"
  subnet_id     = "${aws_subnet.pipeline_1_vpc_subnet_1.id}"
  vpc_security_group_ids  = ["${aws_security_group.pipeline_1_security_group_ec2.id}"]
  key_name = "${aws_key_pair.pipeline_1_key_pair.key_name}"
  tags {
    Name = "Jenkins Box"
    Env  = "jenkins"
  }
  root_block_device {
    volume_size = "40"
  }
}

#create the launch configuration configuration
