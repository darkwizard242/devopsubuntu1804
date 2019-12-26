#!/bin/bash -e

# Shellcheck fixes for: SC2006, SC2086, SC2129, SC2181

# Add vagrant user to sudoers.
{
  echo "vagrant ALL=(ALL) NOPASSWD: ALL"
  echo "ansible ALL=(ALL) NOPASSWD: ALL"
  echo "jenkins ALL=(ALL) NOPASSWD: ALL"
  echo "docker ALL=(ALL) NOPASSWD: ALL"
} >> /etc/sudoers

sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers

# Add vagrant user to sudo group
usermod -aG sudo vagrant

# Disable daily apt unattended updates.
echo 'APT::Periodic::Enable "0";' >> /etc/apt/apt.conf.d/10periodic

DEBIAN_FRONTEND=non-interactive apt-get update -y

# Install necessary libraries for guest additions and Vagrant NFS Share
libraries="linux-headers-$(uname -r) build-essential dkms nfs-common"
for library in $libraries;
do
  if dpkg -s "$library" &> /dev/null;
    then
      echo -e "\n$library is already available and installed within the system.\n"
    else
      echo -e  "\nAbout to install $library.\n"
      DEBIAN_FRONTEND=non-interactive apt-get install "$library" -y
  fi
done

# Install necessary dependencies
dependencies="curl wget tmux xvfb vim inxi screenfetch tree sysstat stress shellcheck"
for dependency in $dependencies;
do
  if dpkg -s "$dependency" &> /dev/null;
    then
      echo -e "\n$dependency is already available and installed within the system.\n"
    else
      echo -e  "\nAbout to install $dependency.\n"
      DEBIAN_FRONTEND=non-interactive apt-get install "$dependency" -y
  fi
done

# Disable all current motd's and only use custom motd.
ls -altr /home/vagrant/
chmod -v -x /etc/update-motd.d/*
mv -v /home/vagrant/mods/00-devops /etc/update-motd.d/ && ls -altr /etc/update-motd.d/
chown -Rv root:root /etc/update-motd.d/00-devops
chmod -v a+x /etc/update-motd.d/00-devops && ls -altr /etc/update-motd.d/
