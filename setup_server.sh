#!/bin/bash

echo "Code Agency Cloud MOTD" > /etc/motd

# Create new user "codeagency" with SSH key
useradd -m -s /bin/bash codeagency
mkdir -p /home/codeagency/.ssh
cp /root/.ssh/id_ed25519.pub /home/codeagency/.ssh/authorized_keys
chown -R codeagency:codeagency /home/codeagency/.ssh

# Add user "codeagency" to sudo and docker groups
usermod -aG sudo codeagency
usermod -aG docker codeagency

# Update and upgrade packages
apt-get update -y
apt-get upgrade -y

# Enable unattended upgrades
apt-get install -y unattended-upgrades
dpkg-reconfigure --priority=low unattended-upgrades

echo "Code Agency Cloud is containerizing your server... Please wait a moment." > /etc/motd
# Install Docker and Docker Compose
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
usermod -aG docker codeagency
systemctl enable docker
systemctl start docker
apt-get install -y docker-compose
echo "Code Agency Cloud is installing essential packages on your server... Please wait a moment."
apt-get install -y build-essential wget curl git
echo "Code Agency Cloud is installing Homebrew on your server... Please wait a moment."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo "Code Agency Cloud is installing Dust on your server... Please wait a moment."
cargo install du-dust -y
echo "Code Agency Cloud is installing CTOP on your server... Please wait a moment."
sudo apt install ctop -y
echo "Your server is now ready. Welcome aboard Code Agency Cloud! Enjoy your new fast server. "
