output "app_public_url" {
  value = "http://${aws_instance.nudpack_server.public_ip}:8000"
}