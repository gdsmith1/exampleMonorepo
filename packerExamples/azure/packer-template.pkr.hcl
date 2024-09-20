packer {
    required_plugins {
        azure = {
            source  = "github.com/hashicorp/azure"
            version = "~> 2"
        }
    }
  }
source "azure-arm" "example" {
  client_id                       = "eb8bae47-dae2-477b-ba21-3ea15b2afde7"
  client_secret                   = "SECRET"
  tenant_id                       = "1b4a4fed-fed8-4823-a8a0-3d5cea83d122"
  subscription_id                 = "3e16852e-8399-4c16-b246-16bf46bc3747"
  managed_image_resource_group_name = "rg-fishes-bootcamp"
  managed_image_name              = "managedimagefishes"
  os_type                         = "Linux"
  image_publisher                 = "canonical"
  image_offer                     = "0001-com-ubuntu-server-jammy"
  image_sku                       = "22_04-lts-gen2"
  location                        = "West US"
  vm_size                         = "Standard_DS1_v2"

  shared_image_gallery_destination {
    subscription = "3e16852e-8399-4c16-b246-16bf46bc3747"
    resource_group = "rg-fishes-bootcamp"
    gallery_name = "sigfishesbootcamp"
    image_name = "packerdeffishes"
    image_version = "1.0.0"
    storage_account_type = "Standard_LRS"
  }
}

build {
  sources = ["source.azure-arm.example"]

  provisioner "shell" {
    pause_before = "30s"
    inline = [
        "mkdir hello-fish",
        "sudo apt-get update",
        "sudo apt-get upgrade -y",
        "sudo apt-get install nginx nodejs npm -y",
        "mkdir -p /etc/nginx/sites-available"
    ]

  }

  provisioner "file" {
    source      = "nginx-default"
    destination = "/tmp/nginx-default"
  }

  provisioner "shell" {
    inline = [
        "sudo mv /tmp/nginx-default /etc/nginx/sites-available/default"
    ]
  }

  provisioner "file" {
    source      = "index.js"
    destination = "/home/packer/hello-fish/index.js"
  }

  provisioner "shell" {
    inline = [
        "sudo service nginx restart",
        "cd hello-fish",
        "npm init -y",
        "npm install express -y"
        #"nodejs index.js"
    ]
  }


  #provisioner "file" {
  #  source = "script.sh"
  #  destination = "/home/packer/script.sh"
  #}

  provisioner "shell" {
    script = "script.sh"
  }
}