output "app_server_public_ip" {
  value       = aws_instance.app_server.public_ip
}

# output "vpc_id" {
#   value       = aws_vpc.main_vpc.id
# }
