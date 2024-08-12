locals {
  resource_name = "${var.project_name}-${var.environment}"
  az_names = slice(data.aws_availability_zones.available_zones.names,0,2)
}