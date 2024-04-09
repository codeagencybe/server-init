# commands

This method will reboot the system as if cloud-init never ran. This command does not remove all cloud-init artefacts from previous runs of cloud-init, but it will clean enough artefacts to allow cloud-init to think that it hasn’t run yet. It will then re-run after a reboot.

```bash
cloud-init clean --logs --reboot
```

https://cloudinit.readthedocs.io/en/latest/howto/rerun_cloud_init.html

## Create user

After the initial comment, let us start by creating a new admin user with sudo privileges and pre-configured SSH key.

```bash
users:
  - name: codeagency
    groups: users, admin, docker
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    ssh_authorized_keys:
      - <public_ssh_key>
```

## Update packages

```bash
packages:
  - fail2ban
  - ufw
package_update: true
package_upgrade: true
```

## Configure fail2ban

```bash
  - printf "[sshd]\nenabled = true\nbanaction = iptables-multiport" > /etc/fail2ban/jail.local
  - systemctl enable fail2ban
```

## Harden SSH

- Deactivate the root login
- Enable user for SSH
- Deactivate password authentication
- Automatic disconnection in case of incorrect login
- Deactivate unused functions

```bash
  - sed -i -e '/^\(#\|\)PermitRootLogin/s/^.*$/PermitRootLogin no/' /etc/ssh/sshd_config
  - sed -i -e '/^\(#\|\)PasswordAuthentication/s/^.*$/PasswordAuthentication no/' /etc/ssh/sshd_config
  - sed -i -e '/^\(#\|\)KbdInteractiveAuthentication/s/^.*$/KbdInteractiveAuthentication no/' /etc/ssh/sshd_config
  - sed -i -e '/^\(#\|\)ChallengeResponseAuthentication/s/^.*$/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config
  - sed -i -e '/^\(#\|\)MaxAuthTries/s/^.*$/MaxAuthTries 2/' /etc/ssh/sshd_config
  - sed -i -e '/^\(#\|\)AllowTcpForwarding/s/^.*$/AllowTcpForwarding no/' /etc/ssh/sshd_config
  - sed -i -e '/^\(#\|\)X11Forwarding/s/^.*$/X11Forwarding no/' /etc/ssh/sshd_config
  - sed -i -e '/^\(#\|\)AllowAgentForwarding/s/^.*$/AllowAgentForwarding no/' /etc/ssh/sshd_config
  - sed -i -e '/^\(#\|\)AuthorizedKeysFile/s/^.*$/AuthorizedKeysFile .ssh\/authorized_keys/' /etc/ssh/sshd_config
  - sed -i '$a AllowUsers codeagency' /etc/ssh/sshd_config
```

## Generate a new SSH key

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

```

## Github deploy key

Create a new deploy key in the Github repository settings with the public key generated above.
**_Leave write access unchecked._**

```bash
cat ~/.ssh/id_ed25519.pub
```
