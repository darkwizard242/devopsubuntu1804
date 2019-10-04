#!/bin/bash -e

# Shellcheck fixes for: SC2086, SC2181, SC2006

## Installing packages required for Terraform
dependencies="wget unzip"

for dependency in $dependencies;
do
  if dpkg -s "$dependency" &> /dev/null;
    then
      echo -e "\n$dependency is already available and installed within the system."
    else
      echo -e "\nAbout to install:\t$dependency"
      DEBIAN_FRONTEND=non-interactive apt-get install "$dependency" -y
  fi
done


## Download Terraform and extract binary to /usr/local/bin/
binary="terraform"
version="0.12.9"
osarch="linux_amd64"
extract_path="/usr/local/bin"
if [ -e $extract_path/$binary ]
then
  ver_existing=$($binary --version)
  echo -e "\n$binary currently exists in:\t$extract_path/$binary"
  echo -e "\nCurrently available version is:\t$ver_existing"
else
  wget -v -O /tmp/${binary}.zip https://releases.hashicorp.com/${binary}/${version}/${binary}_${version}_${osarch}.zip
  unzip /tmp/${binary}.zip -d $extract_path && rm -rv /tmp/${binary}.zip
  ver_fresh=$($binary --version)
  echo -e "\nInstalled version is: $ver_fresh"
fi
