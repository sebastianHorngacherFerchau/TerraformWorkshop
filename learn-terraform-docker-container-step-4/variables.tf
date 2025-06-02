variable "cotainer_name" {
  description = "Description of the container"
  type        = string
  default     = "ExampleContainerFromVariable"
}

variable "environment" {
  description = "The environment to deploy to (dev or prod)"
  type        = string
  default     = "dev"
}


variable "external_port" {
  description = "The external port for the Docker container"
  type        = number
  default     = 8000
}

variable "tags" {
  description = "Tags for the Docker container"
  type = list(object({
    label = string
    value = string
  }))
  default = [{
    label = "label1"
    value = "value1"
    },
    {
      label = "label2"
      value = "value2"
  }]
}