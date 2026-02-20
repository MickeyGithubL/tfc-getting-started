output "vpc_id" {
  description = "ID of the created VPC"
  value       = fakewebservices_vpc.primary_vpc.id
}

output "vpc_name" {
  description = "Name of the created VPC"
  value       = fakewebservices_vpc.primary_vpc.name
}

output "server_names" {
  description = "Names of the created servers"
  value       = fakewebservices_server.servers[*].name
}

output "server_ids" {
  description = "IDs of the created servers"
  value       = fakewebservices_server.servers[*].id
}

output "load_balancer_name" {
  description = "Name of the load balancer"
  value       = fakewebservices_load_balancer.primary_lb.name
}

output "load_balancer_id" {
  description = "ID of the load balancer"
  value       = fakewebservices_load_balancer.primary_lb.id
}

output "database_name" {
  description = "Name of the database"
  value       = fakewebservices_database.prod_db.name
}

output "database_id" {
  description = "ID of the database"
  value       = fakewebservices_database.prod_db.id
}