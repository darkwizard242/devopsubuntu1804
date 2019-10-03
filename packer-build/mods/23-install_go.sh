#!/bin/bash -e


## Installing packages required for go
dependencies="wget git"

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


## Download go and extract binary to /usr/local/
binary="go"
version="1.13"
osarch="linux-amd64"
extract_path="/usr/local"
user_path="/home/vagrant"
if [ -e $extract_path/$binary ]
then
  ver_existing=$($binary version)
  echo -e "\n$binary currently exists in:\t$extract_path/$binary"
  echo -e "\nCurrently available version is:\t$ver_existing"
else
  wget -v -O /tmp/${binary}.zip https://dl.google.com/${binary}/${binary}${version}.${osarch}.tar.gz
  tar -C ${extract_path} -xzf /tmp/${binary}.zip && rm -rv /tmp/${binary}.zip
  mkdir -pv ${user_path}/${binary}/{bin,src}
  echo -e "\nexport GOPATH=${user_path}/${binary}" >> ${user_path}/.bashrc
  source ${user_path}/.bashrc
  echo -e "\nexport PATH=$PATH:${extract_path}/${binary}/bin:$GOPATH/bin" >> ${user_path}/.bashrc
  source ${user_path}/.bashrc
  ver_fresh=$($binary version)
  echo -e "\nInstalled version is: $ver_fresh"
fi
