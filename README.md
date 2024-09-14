# Server Init

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Server Init](#server-init)
  - [Usage](#usage)
  - [Example](#example)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

This repo holds the initial cloud-init configuration to run Hetzner Cloud servers.

## Usage

To use the configuration, add the following line to your `user_data`:

```yaml
#include
https://raw.githubusercontent.com/codeagencybe/server-init/main/cloud-init.yml
```

## Example

To get a minimal working example, here's the TF file to create one server with
public IP to access and verify the configuration:

```terraform
terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.48"
    }
  }
}

resource "tls_private_key" "this" {
  algorithm = "ED25519"
}

resource "hcloud_ssh_key" "this" {
  name       = "codeagency"
  public_key = tls_private_key.this.public_key_openssh
}

resource "hcloud_server" "this" {
  name        = "codeagency"
  image       = "ubuntu-24.04"
  server_type = "cx11"

  ssh_keys = [
    hcloud_ssh_key.this.id,
  ]

  user_data = <<-EOF
    #include
    https://raw.githubusercontent.com/codeagencybe/server-init/main/cloud-init.yml
  EOF

  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }
}

output "public_ip" {
  value     = hcloud_server.this.ipv4_address
  sensitive = true
}

output "ssh_private_key" {
  value     = tls_private_key.this.private_key_openssh
  sensitive = true
}
```

