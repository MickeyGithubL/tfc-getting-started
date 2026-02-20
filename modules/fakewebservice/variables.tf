variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "Primary VPC"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "0.0.0.0/1"
}

variable "server_count" {
  description = "Number of servers to create"
  type        = number
  default     = 2
}

variable "server_type" {
  description = "Type of servers"
  type        = string
  default     = "t2.micro"
}

variable "lb_name" {
  description = "Name of the load balancer"
  type        = string
  default     = "Primary Load Balancer"
}

variable "db_name" {
  description = "Name of the database"
  type        = string
  default     = "Production DB"
}

variable "db_size" {
  description = "Size of the database"
  type        = number
  default     = 256
}