#!/bin/bash -e

# Shellcheck fixes for: SC2181

packages="git"

for package in $packages;
do
  if dpkg -s $package &> /dev/null;
    then
      echo -e "\n$package is already available and installed within the system.\n"
    else
      echo -e "\nAbout to install:\t$package\n"
      DEBIAN_FRONTEND=non-interactive apt-get install $package -y
  fi
done