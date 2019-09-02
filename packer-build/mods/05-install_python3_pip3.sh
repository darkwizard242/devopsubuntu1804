#!/bin/bash -e

# Shellcheck fixes for: SC2086, SC2181, SC2006

## Install python3 and python3-pip
packages="python3 python3-pip"

for package in $packages;
do
  if dpkg -s "$package" &> /dev/null;
    then
      echo -e "\n$package is already available and installed within the system."
    else
      echo -e "\nAbout to install: $package"
      DEBIAN_FRONTEND=non-interactive apt-get install "$package" -y
  fi
done


## Upgrade pip for python3
pip3_ver=$(python3 -m pip --version)

if which pip3;
then
  echo -e "\npip for python3 is installed and is:\t$pip3_ver . Going to upgrade it (if candidate is available).\n"
  python3 -m pip install -U pip
else
  echo "pip for python3 is not available."
fi

