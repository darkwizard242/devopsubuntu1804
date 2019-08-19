#!/bin/bash


## Installing packages required for Hugo
dependencies="wget"

for dependency in $dependencies;
do
  dpkg -s $dependency &> /dev/null && echo -e
  if [ $? -eq 0 ];
    then
      echo "$dependency is already available and installed within the system." && echo -e
    else
      echo "About to install $dependency." && echo -e
      DEBIAN_FRONTEND=non-interactive apt-get install $dependency -y
  fi
done


## Download Hugo and extract binary to /usr/local/bin/
binary="hugo"
version="0.56.0"
osarch="Linux-64bit"
if [ -e /usr/local/bin/hugo ]
then
  ver_existing=`$binary --version`
  echo -e "\n${binary} binary currently exists in /bin/ !"
  echo -e "\nCurrently available version is: $ver_existing"
else
  wget -v -O /tmp/${binary}.tar.gz https://github.com/gohugoio/${binary}/releases/download/v${version}/${binary}_${version}_${osarch}.tar.gz
  tar -zxf /tmp/${binary}.tar.gz -C /usr/local/bin ${binary} && rm -rv /tmp/${binary}.tar.gz
  ver_fresh=`$binary version | awk '{print $5}'`
  echo -e "\nInstalled version of ${binary} is: $ver_fresh\n"
fi

