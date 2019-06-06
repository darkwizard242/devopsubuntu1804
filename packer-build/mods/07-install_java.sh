#!/bin/bash -eu

packages="openjdk-8-jdk"

for package in $packages;
do
  dpkg -s $package &> /dev/null && echo -e
  if [ $? -eq 0 ];
    then
      echo "$package is already available and installed within the system" && echo -e
    else
      echo "About to install $package" && echo -e
      DEBIAN_FRONTEND=non-interactive apt-get install $package -y
  fi
done