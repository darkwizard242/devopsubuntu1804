#!/bin/bash -eux

# apt-get purge -y linux-image-3.0.0-12-generic-pae

# Remove APT cache
apt-get clean -y
apt-get autoclean -y

# Zero free space to aid VM compression
dd if=/dev/zero of=/EMPTY bs=1M
rm -fv /EMPTY

# Remove bash history
unset HISTFILE
rm -fv /root/.bash_history
rm -fv /home/vagrant/.bash_history

# Cleanup log files
find /var/log -type f | while read f; do echo -ne '' > $f; done;

# Whiteout root
count=`df --sync -kP / | tail -n1  | awk -F ' ' '{print $4}'`;
let count--
dd if=/dev/zero of=/tmp/whitespace bs=1024 count=$count;
rm -v /tmp/whitespace;

# Whiteout /boot
count=`df --sync -kP /boot | tail -n1 | awk -F ' ' '{print $4}'`;
let count--
dd if=/dev/zero of=/boot/whitespace bs=1024 count=$count;
rm /boot/whitespace;


swappart=$(cat /proc/swaps | grep -v Filename | tail -n1 | awk -F ' ' '{print $1}')
if [ "$swappart" != "" ]; then
        swapoff $swappart;
        dd if=/dev/zero of=$swappart;
        mkswap $swappart;
        swapon $swappart;
fi

# Remove history
cat /dev/null > ~/.bash_history && history -c
# Add `sync` so Packer doesn't quit too early, before the large file is deleted.
sync
