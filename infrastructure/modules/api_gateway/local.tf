locals {
  routes_by_name = {
    for route in var.routes : route.name => route
  }
}
