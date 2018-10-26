#provider Details
provider "digitalocean" {
  token = "${var.digitalocean_token}"
}

#you can create N number of Droplet creation with ssh key and
#enter the count of droplets by replacing count value

resource "digitalocean_droplet" "servers" {
  count              = 1
  image              = "ubuntu-16-04-x64"
  name               = "master${count.index}"
  region             = "blr1"
  size               = "s-2vcpu-2gb"
  backups            = false
  private_networking = true
  ssh_keys           = [your _key value]

  connection {
    user        = "root"
    type        = "ssh"
    private_key = "${file("${var.ssh_private_key_path}")}"
  }

  provisioner "remote-exec" {
    inline = [
      "apt update",
      "apt upgrade -y",
      "apt install -y docker.io",
    ]

    on_failure = "continue"
  }
}

#will print the output of the ip

output "ip" {
  value = "${digitalocean_droplet.masters.*.ipv4_address}"
}
