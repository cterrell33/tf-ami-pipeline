resource "random_id" "this" {
  byte_length = 8
}

resource "aws_security_group" "mastersg"{
    name        = var.security_group_name
    vpc_id      = var.vpc_id
    dynamic "ingress" {
        for_each = var.rules
        content {
            description     = ingress.value["description"]
            from_port       = ingress.value["from_port"]
            to_port         = ingress.value["to_port"]
            protocol        = ingress.value["protocol"]
            cidr_blocks     = ingress.value["cidr_blocks"]
        }
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["10.0.0.0/8"]
    }
}