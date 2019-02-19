#!/bin/bash -eux

# Add vagrant user to sudoers.
echo "vagrant        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers

# Disable daily apt unattended updates.
echo 'APT::Periodic::Enable "0";' >> /etc/apt/apt.conf.d/10periodic

DEBIAN_FRONTEND=non-interactive apt-get update -y

# Install necessary libraries for guest additions and Vagrant NFS Share
DEBIAN_FRONTEND=non-interactive apt-get install linux-headers-$(uname -r) build-essential dkms nfs-common -y

# Install necessary dependencies
DEBIAN_FRONTEND=non-interactive apt-get install curl wget tmux xvfb vim inxi screenfetch -y

# Disable all current motd's and only use custom motd.
ls -altr /home/vagrant/
chmod -x /etc/update-motd.d/*
cp -R /home/vagrant/00-custom_motd /etc/update-motd.d/ && ls -altr /etc/update-motd.d/
chown -R root:root /etc/update-motd.d/00-custom_motd
chmod +x /etc/update-motd.d/00-custom_motd
