#### Project ####
variable "project_name"{
    type = string
}

variable "environment"{
    type = string
    default = "dev"
}

variable "common_tags"{
    type = map
}
 
#### vpc #####

variable "vpc_cidr_block" {
    type = string
    default = "10.0.0.0/16"
}

variable "enable_dns_hostnames" {
    type = bool
    default = true
}


variable "vpc_tags" {
    type = map
    default = {}
}


#### Internet Gate way #####
variable "gw_tags" {
    type = map
    default = {}
}   


#### public subnet #####
variable "public_subnet_cidrs" {
    type = list
    validation {
      condition = length(var.public_subnet_cidrs) == 2
      error_message = "Please provide 2 valid public subnet CIDR"
    
    }
}

variable "public_subnet_tags" {
    type = map
    default = {}
}


#### private subnet ####
variable "private_subnet_cidrs" {
    type = list
    validation {
      condition = length(var.private_subnet_cidrs) == 2
      error_message = "Please provide 2 valid private subnet CIDR"
    }
}

variable "private_subnet_tags" {
    type = map
    default = {}
}


#### Database subnet #####
variable "database_subnet_cidrs" {
    type = list
    validation {
      condition = length(var.database_subnet_cidrs) == 2
      error_message = "Please provide 2 valid databse subnet CIDR"
    }
    
}

variable "database_subnet_tags" {
    type = map
    default = {}
}


#### NAT Gate Way #####
variable "nat_gate_way_tags" {
    type = map
    default = {}
}


#### Public Route table #####
variable "public_route_tags" {
    type = map
    default = {}
}


#### Private Route table #####
variable "private_route_tags" {
    type = map
    default = {}
}


#### Database Route table #####
variable "database_route_tags" {
    type = map
    default = {}
}

##### Peering #####

variable "is_peering_required" {
    type = bool
    default = false
      
}

variable "accepter_vpc_id" {
  type = string
  default = ""
}

variable "vpc_peering_tags" {
    type = map
    default = {}
}