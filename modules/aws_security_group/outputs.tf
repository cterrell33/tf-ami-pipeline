output "aws_security_group_arn" {
    value = aws_security_group.mastersg.arn
    description = "mastersg arn"
}

output "id"{
    value = aws_security_group.mastersg.id
    description = "mastersg id"
}
