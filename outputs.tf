output "vpc_id" {
    value = aws_vpc.main.id
  
}


output "azs" {
    value = data.aws_availability_zones.available_zones
  
}

output "public_subnets" {
    value = aws_subnet.public
  
}

output "private_subnets" {
    value = aws_subnet.private
  
}

output "database_subnets" {
    value = aws_subnet.database
  
}

output "nat" {
    value = aws_nat_gateway.nat
  
}

output "elastic_ip" {
    value = aws_eip.elastic_ip
  
}