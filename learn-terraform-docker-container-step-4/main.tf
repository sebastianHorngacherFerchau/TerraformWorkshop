terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {
  host = "npipe:////.//pipe//docker_engine"
}

resource "docker_image" "nginx" {
  name         = "nginx"
  keep_locally = false
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name  = "${var.cotainer_name}-${var.environment}"

  dynamic "labels" {
    for_each = var.tags
    content {
      label = labels.value.label
      value = labels.value.value
    }
  }

  ports {
    internal = 80
    external = var.external_port
  }

  network_mode = "bridge"
  pid_mode     = "private"
  ulimit {
    hard = 1048576
    name = "RLIMIT_NOFILE"
    soft = 1048576
  }
  ulimit {
    hard = 127690
    name = "RLIMIT_NPROC"
    soft = 127690
  }
}
