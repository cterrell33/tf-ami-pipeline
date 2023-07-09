variable "security_group_name"{
    type = string
}
variable "vpc_id"{
    type = string
}

variable "rules" {
    type = list(object({
        description     = string
        from_port       = number
        to_port         = number
        protocol        = string
        cidr_blocks     = list(string)
    }))
    default = [
        {
            description  = "allow ping"
            from_port    = -1
            to_port      = -1
            protocol     = "icmp"
            cidr_blocks  = ["10.0.0.0/8"]
        },
        {
            description  = "OSE Browser - HTTPS"
            from_port    = 443
            to_port      = 443
            protocol     = "tcp"
            cidr_blocks  = ["172.30.3.0/24"]
        },
        {
            description  = "Syslog"
            from_port    = 514
            to_port      = 514
            protocol     = "tcp"
            cidr_blocks  = ["10.0.0.0/8"]
        },
        {
            description  = "Splunk Forwarder"
            from_port    = 9997
            to_port      = 9997
            protocol     = "tcp"
            cidr_blocks  = ["10.0.0.0/8"]
        },
        {
            description  = "Unknown" 
            from_port    = 5693
            to_port      = 5693
            protocol     = "tcp"
            cidr_blocks  = ["10.0.0.0/8"]
        },
        {
            description  = "Unknown"
            from_port    = 8081
            to_port      = 8081
            protocol     = "tcp"
            cidr_blocks  = ["10.0.0.0/8"]
        },
        {
            description  = "OSE Browser - HTTP"
            from_port    = 80
            to_port      = 80
            protocol     = "tcp"
            cidr_blocks  = ["172.30.3.0/24"]
        },
        {
            description  = "ssh"
            from_port    = 22
            to_port      = 22
            protocol     = "tcp"
            cidr_blocks  = ["10.0.0.0/8"]
        },
        {
            description  = "Splunk daemon management"
            from_port    = 8089
            to_port      = 8089
            protocol     = "tcp"
            cidr_blocks  = ["10.0.0.0/8"]
        },
        {
            description  = "Syslog"
            from_port    = 514
            to_port      = 514
            protocol     = "udp"
            cidr_blocks  = ["10.0.0.0/8"]
        },
        {
            description  = "SNMP"  
            from_port    = 161
            to_port      = 161
            protocol     = "udp"
            cidr_blocks  = ["10.0.0.0/8"]
        },
        {
            description  = "Unknown"            
            from_port    = 8082
            to_port      = 8082
            protocol     = "udp"
            cidr_blocks  = ["10.0.0.0/8"]
        },
        {
            description  = "SNMP Trap"
            from_port    = 162
            to_port      = 162
            protocol     = "udp"
            cidr_blocks  = ["10.0.0.0/8"]
        }
    ]
}