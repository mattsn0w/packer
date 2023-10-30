packer {
  required_plugins {
    sshkey = {
      version = ">= 1.0.1"
      source = "github.com/ivoronin/sshkey"
    }
    libvirt = {
      version = ">= 0.5.0"
      source  = "github.com/thomasklein94/libvirt"
    }
  }
}

data "sshkey" "install" {
}

source "libvirt" "remote" {
  libvirt_uri = "qemu+ssh://msnow@brick2.co.slakin.net/system?no_verify=1&keyfile=/home/msnow/.ssh/id_rsa"

  vcpu   = 1
  memory = 1024

  network_interface {
#    type  = "managed"
    type  = "bridge"
    alias = "communicator"
    bridge = "virbr0"
  }

  # https://developer.hashicorp.com/packer/plugins/builders/libvirt#communicators-and-network-interfaces
  communicator {
    communicator         = "ssh"
    ssh_username         = "ubuntu"
    ssh_private_key_file = data.sshkey.install.private_key_path
  }
  network_address_source = "agent"
  #network_address_source = "arp"

  volume {
    alias = "artifact"
    pool = "tfpool"

    source {
      type     = "external"
      # With newer releases, the URL and the checksum can change.
      urls     = ["https://cloud-images.ubuntu.com/releases/22.04/release-20231026/ubuntu-22.04-server-cloudimg-amd64-disk-kvm.img"]
      checksum = "b5d1f937341fbb3afb50d28c4a17f41419df4d87a96d5e737a39b6cb42e1dff3"
    }

    capacity   = "10G"
    bus        = "sata"
    format     = "qcow2"
  }

  volume {
    pool = "tfpool"
    source {
      type = "cloud-init"
      user_data = templatefile("cloud-init-template.yaml", {
          ssh_key = data.sshkey.install.public_key
          })
    }
    bus        = "sata"
  }
  shutdown_mode = "acpi"
}

build {
  sources = ["source.libvirt.remote"]
  provisioner "shell" {
    inline = [
      "echo ################################################################################",
      "echo The domain has started and became accessible",
      "echo The domain has the following addresses",
      "echo ################################################################################",
      "ip -br a",
      "df -hl",
      "echo ################################################################################",
      "df -hl",
      "echo if you want to connect via SSH use the following key: ${data.sshkey.install.private_key_path}",
      "sleep 300",
    ]
  }
#  provisioner "breakpoint" {
#    note = "You can examine the created domain with virt-manager, virsh or via SSH"
#  }
}

