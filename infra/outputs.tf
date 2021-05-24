output "instance_ip" {
  value = aws_instance.server.public_ip
}

output "db_user" {
  value = aws_docdb_cluster.docdb.master_username
}

output "db_pass" {
  value     = aws_docdb_cluster.docdb.master_password
  sensitive = true
}

output "db_url" {
  value = aws_docdb_cluster.docdb.endpoint
}

output "db_port" {
  value = aws_docdb_cluster.docdb.port
}

output "lb_dns" {
  value = aws_lb.todo_app.dns_name
}