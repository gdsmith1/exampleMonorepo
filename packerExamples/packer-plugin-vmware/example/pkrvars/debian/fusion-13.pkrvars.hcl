# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

cdrom_adapter_type   = "sata"
data_directory       = "data/debian"
disk_adapter_type    = "sata"
network_adapter_type = "e1000e"
iso_url              = "https://cdimage.debian.org/cdimage/archive/11.9.0/arm64/iso-dvd/debian-11.9.0-arm64-DVD-1.iso"
iso_checksum         = "b42fa55a013181eb77a088a13baa595ce3fff2237d1d1ccdb7f5702c22bdf4b5"
guest_os_type        = "arm-debian-64"
hardware_version     = 20
boot_command         = ["<wait><up>e<wait><down><down><down><right><right><right><right><right><right><right><right><right><right><right><right><right><right><right><right><right><right><right><right><right><right><right><right><right><right><right><right><right><right><right><right><right><right><wait>install <wait> preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg <wait>debian-installer=en_US.UTF-8 <wait>auto <wait>locale=en_US.UTF-8 <wait>kbd-chooser/method=us <wait>keyboard-configuration/xkb-keymap=us <wait>netcfg/get_hostname={{ .Name }} <wait>netcfg/get_domain={{ .Name }} <wait>fb=false <wait>debconf/frontend=noninteractive <wait>console-setup/ask_detect=false <wait>console-keymaps-at/keymap=us <wait>grub-installer/bootdev=/dev/sda <wait><f10><wait>"]
vm_name              = "debian_aarch64"
vmx_data = {
  "cpuid.coresPerSocket"    = "2"
  "ethernet0.pciSlotNumber" = "32"
  "svga.autodetect"         = true
  "usb_xhci.present"        = true
}
