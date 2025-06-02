variable "listOfObjects" {
  type = list(object({
    name    = string
    content = string
  }))
  default = [{
    name    = "first file"
    content = "This is the content of file 1"
    }, {
    name    = "second file"
    content = "This is the content of file 2"
    }, {
    name    = "another one"
    content = "This is the content of file 3"
  }]
}