#!/bin/bash -eux

# Mod for setting up vagrant keys.

mkdir ~/.ssh
chmod 700 ~/.ssh
cd ~/.ssh
# https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub
wget --no-check-certificate 'https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub' -O authorized_keys
chmod 600 ~/.ssh/authorized_keys
chown -R vagrant ~/.ssh


# Custom VBoxAdditions mount and setup required by vagrant
mkdir -p /mnt/virtualbox
mount -o loop /home/vagrant/VBoxGuest*.iso /mnt/virtualbox
sh /mnt/virtualbox/VBoxLinuxAdditions.run
ln -s /opt/VBoxGuestAdditions-*/lib/VBoxGuestAdditions /usr/lib/VBoxGuestAdditions
umount /mnt/virtualbox
rm -rf /home/vagrant/VBoxGuest*.iso

cat /home/vagrant/.ssh/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys

mkdir -p /home/vagrant/.ansible/tmp
chown -R vagrant:vagrant /home/vagrant/.ansible/tmp
chmod -R 777 /home/vagrant/.ansible/tmp