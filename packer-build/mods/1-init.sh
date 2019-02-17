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
DEBIAN_FRONTEND=non-interactive apt-get install curl wget tmux xvfb vim -y