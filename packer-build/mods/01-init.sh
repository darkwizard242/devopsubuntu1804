#!/bin/bash -eux

# Add vagrant user to sudoers.
echo "vagrant ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
echo "ansible ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
echo "docker ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers

# Add vagrant user to sudo group
usermod -aG sudo vagrant

# Disable daily apt unattended updates.
echo 'APT::Periodic::Enable "0";' >> /etc/apt/apt.conf.d/10periodic

DEBIAN_FRONTEND=non-interactive apt-get update -y

# Install necessary libraries for guest additions and Vagrant NFS Share
DEBIAN_FRONTEND=non-interactive apt-get install linux-headers-$(uname -r) build-essential dkms nfs-common -y

# Install necessary dependencies
DEBIAN_FRONTEND=non-interactive apt-get install curl wget tmux xvfb vim inxi screenfetch tree -y

# Disable all current motd's and only use custom motd.
ls -altr /home/vagrant/
chmod -x /etc/update-motd.d/*
cp -R /home/vagrant/00-devops /etc/update-motd.d/ && ls -altr /etc/update-motd.d/
chown -R root:root /etc/update-motd.d/00-devops
chmod a+x /etc/update-motd.d/00-devops && ls -altr /etc/update-motd.d/
