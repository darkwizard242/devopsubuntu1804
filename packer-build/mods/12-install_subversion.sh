#!/bin/bash -e

# Shellcheck fixes for: SC2181

## Install subversion
packages="subversion"

for package in $packages;
do
  if dpkg -s $package &> /dev/null;
    then
      echo -e "$package is already available and installed within the system.\n"
    else
      echo -e "About to install:\t$package\n"
      DEBIAN_FRONTEND=non-interactive apt-get install $package -y
  fi
done

