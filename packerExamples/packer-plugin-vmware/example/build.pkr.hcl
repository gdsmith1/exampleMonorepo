# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0
# From this folder, run: rm -rf builds/debian_aarch64 && packer init . && packer build -var-file=pkrvars/debian/fusion-13.pkrvars.hcl .

packer {
  required_version = ">= 1.7.0"
  required_plugins {
    vmware = {
      version = "~> 1.0.7"
      source  = "github.com/hashicorp/vmware"
    }
    vagrant = {
        version = "~> 1"
        source  = "github.com/hashicorp/vagrant"
    }
  }
}

build {
  sources = ["source.vmware-iso.debian"]
  provisioner "shell" {
    inline = [
    "sudo apt-get update",
    "sudo apt-get upgrade",
    "sudo apt-get dist-upgrade -y",
    "sudo apt-get install -y openjdk-11-jdk",
    "wget https://download.sonatype.com/nexus/3/nexus-3.69.0-02-java11-mac.tgz",
    "tar -xvf nexus-3.69.0-02-java11-mac.tgz",
    ]
  }
  post-processor "vagrant" {
      output = "output-vmware-iso/package.box"
      keep_input_artifact = true # keeps the build folder
  }
  post-processor "vagrant" {
    output = "output-vmware-iso/package.vmx"
    keep_input_artifact = true 
  }


}
