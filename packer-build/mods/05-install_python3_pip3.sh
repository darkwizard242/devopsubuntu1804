#!/bin/bash -eux

## Install python3 and python3-pip
packages="python3 python3-pip"

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


## Upgrade pip for python3
pip3_ver=`python3 -m pip --version`
if [ $? -eq 0 ];
then
  echo "pip for python3 is installed and is: $pip3_ver . Going to upgrade it (if candidate is available)." 
  python3 -m pip install -U pip
else
  echo "pip for python3 is not available."
fi

