# Copyright IBM Corp. 2020, 2024
# SPDX-License-Identifier: MPL-2.0

# The following configuration uses a provider which provisions [fake] resources
# to a fictitious cloud vendor called "Fake Web Services". Configuration for
# the fakewebservices provider can be found in provider.tf.
#
# After running the setup script (./scripts/setup.sh), feel free to change these
# resources and 'terraform apply' as much as you'd like! These resources are
# purely for demonstration and created in HCP Terraform, scoped to your HCP Terraform
# user account.
#
# To review the provider and documentation for the available resources and
# schemas, see: https://registry.terraform.io/providers/hashicorp/fakewebservices
#
# If you're looking for the configuration for the remote backend, you can find that
# in backend.tf.

module "fakewebservice" {
  source = "./modules/fakewebservice"

  vpc_name       = "Primary VPC"
  vpc_cidr_block = "0.0.0.0/1"
  server_count   = 3
  server_type    = "t2.micro"
  lb_name        = "Primary Load Balancer"
  db_name        = "Production DB"
  db_size        = 256
}

# Moved blocks to indicate resources moved to the module
moved {
  from = fakewebservices_vpc.primary_vpc
  to   = module.fakewebservice.fakewebservices_vpc.primary_vpc
}

moved {
  from = fakewebservices_server.servers
  to   = module.fakewebservice.fakewebservices_server.servers
}

resource "fakewebservices_server" "server-3" {
  name = "Server 3" 
  type = "t2.macro" 
}

resource "fakewebservices_server" "server-4" {
  name = "Server 4" 
  type = "t2.macro" 
}

resource "fakewebservices_server" "server-5" {
  name = "Server 5" 
  type = "t2.small" 
}

resource "fakewebservices_server" "server-6" {
  name = "Server 6" 
  type = "t2.small" 
}

moved {
  from = fakewebservices_load_balancer.primary_lb
  to   = module.fakewebservice.fakewebservices_load_balancer.primary_lb
}

moved {
  from = fakewebservices_database.prod_db
  to   = module.fakewebservice.fakewebservices_database.prod_db
}

resource "fakewebservices_database" "staging_db" {
  name = "Staging DB"
  size = 128
}

resource "fakewebservices_load_balancer" "f5" {
  name    = "F5 Load Balancer"
  servers = [fakewebservices_server.server-3.name, fakewebservices_server.server-4.name, fakewebservices_server.server-5.name, fakewebservices_server.server-6.name]
}

resource "fakewebservices_load_balancer" "secondary_lb" {
  name    = "Secondary Load Balancer"
  servers = [fakewebservices_server.server-5.name, fakewebservices_server.server-6.name]
}

# Outputs from the module
output "vpc_id" {
  value = module.fakewebservice.vpc_id
}

output "vpc_name" {
  value = module.fakewebservice.vpc_name
}

output "server_names" {
  value = module.fakewebservice.server_names
}

output "server_ids" {
  value = module.fakewebservice.server_ids
}

output "load_balancer_name" {
  value = module.fakewebservice.load_balancer_name
}

output "load_balancer_id" {
  value = module.fakewebservice.load_balancer_id
}

output "database_name" {
  value = module.fakewebservice.database_name
}

output "database_id" {
  value = module.fakewebservice.database_id
}

output "staging_database_name" {
  value = fakewebservices_database.staging_db.name
}

output "staging_database_id" {
  value = fakewebservices_database.staging_db.id
}

output "secondary_load_balancer_name" {
  value = fakewebservices_load_balancer.secondary_lb.name
}

output "secondary_load_balancer_id" {
  value = fakewebservices_load_balancer.secondary_lb.id
}
