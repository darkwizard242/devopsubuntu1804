#!/bin/bash -e

# Shellcheck fixes for: SC2181, SC2006

## Installing packages required for Hugo
dependencies="wget"

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


## Download Hugo and extract binary to /usr/local/bin/
binary="hugo"
version="0.58.3"
osarch="Linux-64bit"
extract_path="/usr/local/bin"
if [ -e $extract_path/$binary ]
then
  ver_existing=$($binary --version)
  echo -e "\n$binary currently exists in:\t$extract_path/$binary"
  echo -e "\nCurrently available version is:\t$ver_existing"
else
  wget -v -O /tmp/${binary}.tar.gz https://github.com/gohugoio/${binary}/releases/download/v${version}/${binary}_${version}_${osarch}.tar.gz
  tar -zxf /tmp/${binary}.tar.gz -C /usr/local/bin ${binary} && rm -rv /tmp/${binary}.tar.gz
  ver_fresh=$(${binary} version | awk '{print $5}')
  echo -e "\nInstalled version of ${binary} is:\t$ver_fresh\n"
fi
