resource "aws_security_group" "access-ssh" {
    name = "acesso-ssh"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
      Name = "ssh"
    }
}

resource "aws_instance" "instances_ec2" {
    ami                         = "ami-053b0d53c279acc90"
    count                       = 1
    instance_type               = "t2.micro"
    key_name                    = "job_tf_aws"
    monitoring                  = true
    vpc_security_group_ids      = [aws_security_group.access-ssh.id]
    associate_public_ip_address = true
    tags = {
      "Name" = "${var.project_name}-ubuntu-server-${var.environment}"
    }
    ebs_block_device {
        device_name = "/dev/sdh"
        volume_size = 100
        volume_type = "gp3"
    }
   
}