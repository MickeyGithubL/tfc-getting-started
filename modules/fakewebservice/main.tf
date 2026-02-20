resource "fakewebservices_vpc" "primary_vpc" {
  name       = var.vpc_name
  cidr_block = var.vpc_cidr_block
}

resource "fakewebservices_server" "servers" {
  count = var.server_count

  name = "Server ${count.index + 1}"
  type = var.server_type
  vpc  = fakewebservices_vpc.primary_vpc.name
}

resource "fakewebservices_load_balancer" "primary_lb" {
  name    = var.lb_name
  servers = fakewebservices_server.servers[*].name
}

resource "fakewebservices_database" "prod_db" {
  name = var.db_name
  size = var.db_size
}