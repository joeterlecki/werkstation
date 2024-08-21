packer {
  required_plugins {
    docker = {
      version = ">= 1.0.10"
      source  = "github.com/hashicorp/docker"
    }
    ansible = {
      version = ">= 1.1.1"
      source  = "github.com/hashicorp/ansible"
    }
  }
}

source "docker" "fedora40" {
  image  = "fedora:40"
  commit = true
}

build {
  sources = ["source.docker.fedora40"]

  provisioner "ansible" {
    playbook_file = "./playbook.yaml"
    extra_arguments = [ "--scp-extra-args", "'-O'" ]
  }

  post-processor "docker-tag" {
    repository = "fedora40-custom"
    tags       = ["latest"]
  }
}
