


# Pre-requisites 
- Machine with memory and storage capable of hosting virtual machines.
- CPU with virtualization extension support and enabled in the BIOS. 
- Linux OS with native libvirt packages.

# Commands
## packer
```
packer init file.pkr.hcl
packer validate file.pkr.hcl
packer build file.pkr.hcl
```

## virsh
These are useful commands to view, and troubleshoot 
```
virsh list --all
virsh pool-info --pool tfpool
virsh console --domain packer-ckvid7sle4mtbqafe32g
virsh domifaddr --source agent --domain packer-ckvid7sle4mtbqafe32g
```

### Volume clean up
These are house keeping steps to remove volumes from the pool where images are built.
```
virsh vol-list --pool tfpool --details
virsh vol-delete --pool tfpool --vol packer-ckvfhpcle4msvl55cgt0-ua-artifact
```


# References
https://developer.hashicorp.com/packer/docs/templates/hcl_templates/blocks 
https://developer.hashicorp.com/packer/docs/templates/hcl_templates/blocks/build
https://developer.hashicorp.com/packer/docs/templates/hcl_templates/blocks/build/provisioner
https://cloudinit.readthedocs.io/en/latest/explanation/introduction.html
https://developer.hashicorp.com/packer/plugins/builders/libvirt
https://developer.hashicorp.com/packer/plugins/datasources/sshkey



# Example output

```
$ packer build example-ubuntu-jammy.pkr.hcl 
Warning: Volume name was not set, using 'packer-ckvik4sle4mtn276oq3g-ua-artifact' as volume name instead.

  on example-ubuntu-jammy.pkr.hcl line 17:
  (source code not available)


libvirt.local: output will be in this color.

==> libvirt.local: Preparing volumes...
    libvirt.local: Preparing volume tfpool/packer-ckvik4sle4mtn276oq3g-ua-artifact
==> libvirt.local: Retrieving tfpool/packer-ckvik4sle4mtn276oq3g-ua-artifact
==> libvirt.local: Trying https://cloud-images.ubuntu.com/releases/22.04/release-20231026/ubuntu-22.04-server-cloudimg-amd64-disk-kvm.img
==> libvirt.local: Trying https://cloud-images.ubuntu.com/releases/22.04/release-20231026/ubuntu-22.04-server-cloudimg-amd64-disk-kvm.img?checksum=b5d1f937341fbb3afb50d28c4a17f41419df4d87a96d5e737a39b6cb42e1dff3
==> libvirt.local: https://cloud-images.ubuntu.com/releases/22.04/release-20231026/ubuntu-22.04-server-cloudimg-amd64-disk-kvm.img?checksum=b5d1f937341fbb3afb50d28c4a17f41419df4d87a96d5e737a39b6cb42e1dff3 => /home/msnow/.cache/packer/ebf391cb3db07fa264c3221a2a10d70fd445ebfe
    libvirt.local: Resizing volume tfpool/packer-ckvik4sle4mtn276oq3g-ua-artifact to meet capacity 10GiB
    libvirt.local: Preparing volume tfpool/packer-ckvik4sle4mtn276oq3g-cloudinit
    libvirt.local: Assembling CloudInit image tfpool/packer-ckvik4sle4mtn276oq3g-cloudinit
==> libvirt.local: Creating CD disk...
    libvirt.local: Warning: creating filesystem with Joliet extensions but without Rock Ridge
    libvirt.local: extensions. It is highly recommended to add Rock Ridge.
    libvirt.local: I: -input-charset not specified, using utf-8 (detected in locale settings)
    libvirt.local: Total translation table size: 0
    libvirt.local: Total rockridge attributes bytes: 0
    libvirt.local: Total directory bytes: 156
    libvirt.local: Path table size(bytes): 10
    libvirt.local: Max brk space used 0
    libvirt.local: 182 extents written (0 MB)
    libvirt.local: Done copying paths from CD_dirs
==> libvirt.local: Sending the domain definition to libvirt
==> libvirt.local: Starting the Libvirt domain
==> libvirt.local: Waiting for SSH to become available...
==> libvirt.local: Connected to SSH!
==> libvirt.local: Provisioning with shell script: /tmp/packer-shell1757658563
    libvirt.local:
    libvirt.local: The domain has started and became accessible
    libvirt.local: The domain has the following addresses
    libvirt.local:
    libvirt.local: lo               UNKNOWN        127.0.0.1/8 ::1/128
    libvirt.local: ens2             UP             172.16.1.234/24 metric 100 fe80::5054:ff:fe46:69fa/64
    libvirt.local: Filesystem      Size  Used Avail Use% Mounted on
    libvirt.local: tmpfs            99M  572K   98M   1% /run
    libvirt.local: /dev/sda1       9.6G  1.9G  7.7G  20% /
    libvirt.local: tmpfs           493M     0  493M   0% /dev/shm
    libvirt.local: tmpfs           5.0M     0  5.0M   0% /run/lock
    libvirt.local: /dev/sda15      105M  6.1M   99M   6% /boot/efi
    libvirt.local: tmpfs            99M  4.0K   99M   1% /run/user/1000
    libvirt.local:
    libvirt.local: Filesystem      Size  Used Avail Use% Mounted on
    libvirt.local: tmpfs            99M  572K   98M   1% /run
    libvirt.local: /dev/sda1       9.6G  1.9G  7.7G  20% /
    libvirt.local: tmpfs           493M     0  493M   0% /dev/shm
    libvirt.local: tmpfs           5.0M     0  5.0M   0% /run/lock
    libvirt.local: /dev/sda15      105M  6.1M   99M   6% /boot/efi
    libvirt.local: tmpfs            99M  4.0K   99M   1% /run/user/1000
    libvirt.local: if you want to connect via SSH use the following key: /home/msnow/.cache/packer/ssh_private_key_packer_rsa.pem
==> libvirt.local: Shutting down libvirt domain...
==> libvirt.local: Domain gracefully stopped
==> libvirt.local: Undefining the domain...
==> libvirt.local: Cleaning up volumes...
    libvirt.local: Cleaning up volume tfpool/packer-ckvik4sle4mtn276oq3g-cloudinit
Build 'libvirt.local' finished after 8 minutes 56 seconds.

==> Wait completed after 8 minutes 56 seconds

==> Builds finished. The artifacts of successful builds are:
--> libvirt.local: Libvirt volume tfpool/packer-ckvik4sle4mtn276oq3g-ua-artifact in qcow2 format was generated
matt@brick:~/packer$ 

```
