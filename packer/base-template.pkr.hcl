packer {
    required_plugins {
        virtualbox = {
          version = "~> 1"
          source  = "github.com/hashicorp/virtualbox"
        }
    }
}


variable "iso_path" {
  type    = string
  default = "/path/to/your/ubuntu-20.04.1-live-server-amd64.iso"
}

variable "iso_checksum" {
  type    = string
  default = "sha256:1d767d13dfb2b74d5a68f7c5ba5d39f25e9424e1dc1fbf7be3a295fa603cb7bc"
}

source "virtualbox-iso" "ubuntu" {
  vm_name = "ubuntu-cyber-range"

  iso_url      = var.iso_path
  iso_checksum = var.iso_checksum

  ssh_username = "packer"
  ssh_password = "packer"
  ssh_wait_timeout = "20m"

  guest_os_type = "Ubuntu_64"

  disk_size = 10240

  http_directory = "http"

  boot_command = [
    "<esc><wait>",
    "linux auto=true priority=critical url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg<enter>"
  ]

  shutdown_command = "echo 'packer' | sudo -S shutdown -P now"
}

build {
  sources = ["source.virtualbox-iso.ubuntu"]

  provisioner "shell" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get upgrade -y",
      "sudo apt-get install -y apache2"
    ]
  }
}
