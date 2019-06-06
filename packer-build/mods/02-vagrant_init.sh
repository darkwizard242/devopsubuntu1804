#!/bin/bash -eu

# Mod for setting up vagrant keys.

mkdir -v ~/.ssh
chmod -v 700 ~/.ssh
cd ~/.ssh
# https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub
wget --no-check-certificate 'https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub' -O authorized_keys
chmod -v 600 ~/.ssh/authorized_keys
chown -Rv vagrant ~/.ssh


# Custom VBoxAdditions mount and setup required by vagrant
mkdir -pv /mnt/virtualbox
mount -v -o loop /home/vagrant/VBoxGuest*.iso /mnt/virtualbox
sh /mnt/virtualbox/VBoxLinuxAdditions.run
ln -vs /opt/VBoxGuestAdditions-*/lib/VBoxGuestAdditions /usr/lib/VBoxGuestAdditions
umount -v /mnt/virtualbox
rm -rfv /home/vagrant/VBoxGuest*.iso

cat /home/vagrant/.ssh/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys

mkdir -pv /home/vagrant/.ansible/tmp
chown -Rv vagrant:vagrant /home/vagrant/.ansible/tmp
chmod -v -R 777 /home/vagrant/.ansible/tmp