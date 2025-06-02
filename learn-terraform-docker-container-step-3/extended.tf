variable "cotainer_name_special" {
  description = "Description of the container"
  type        = string
  default     = "ExampleContainerFromVariable"
}

variable "container_names" {
  description = "values for container names"
  type = map(object({
    name = string
    port = number
  }))
  default = {
    "container1" = { 
      name = "container1"
      port = 8080
    } 
  }
}