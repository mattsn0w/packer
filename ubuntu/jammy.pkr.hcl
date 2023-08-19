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

source "libvirt" "ubuntu-jammy" {
  libvirt_uri = "qemu:///system"

  vcpu   = 1
  memory = 846

  network_interface {
    type  = "bridge"
    bridge = "virbr0" 
    alias = "communicator"
  }

  # https://developer.hashicorp.com/packer/plugins/builders/libvirt#communicators-and-network-interfaces
  communicator {
    communicator         = "ssh"
    ssh_username         = "ubuntu"
    ssh_private_key_file = data.sshkey.install.private_key_path
  }
  network_address_source = "agent"

  volume {
    alias = "artifact"

    source {
      type     = "external"
      # With newer releases, the URL and the checksum can change.
      urls     = ["https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64-disk-kvm.img"]
      checksum = "68d06b21a53282da413012297584a69bf818f61cdfee0b72067327982e4d4267"
    }

    capacity   = "10G"
    bus        = "sata"
    format     = "qcow2"
  }

  volume {
    source {
      type = "cloud-init"
      user_data = format("#cloud-config\n%s", jsonencode({
        packages = [
            "qemu-guest-agent",
        ]
        runcmd = [
            ["systemctl", "enable", "--now", "qemu-guest-agent"],
        ]
        ssh_authorized_keys = [
          data.sshkey.install.public_key,
        ]
      }))
    }
    bus        = "sata"
  }
#  shutdown_mode = "acpi"
}

build {
  sources = ["source.libvirt.ubuntu-jammy"]
  provisioner "shell" {
    inline = [
      "echo The domain has started and became accessible",
      "echo The domain has the following addresses",
      "ip -br a",
      "echo if you want to connect via SSH use the following key: ${data.sshkey.install.private_key_path}",
    ]
  }
  provisioner "breakpoint" {
    note = "You can examine the created domain with virt-manager, virsh or via SSH"
  }
}
