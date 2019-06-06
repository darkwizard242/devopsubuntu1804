#!/bin/bash -eu


## Installing packages required for docker-ce
dependencies="apt-transport-https ca-certificates curl software-properties-common"

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


## Installing docker-ce
package="docker-ce"
dpkg -s $package &> /dev/null && echo -e
if [ $? -eq 0 ];
  then
    echo "$package is already available and installed within the system." && echo -e
  else
    echo "About to install $package." && echo -e
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
    DEBIAN_FRONTEND=non-interactive apt-get update -y
    DEBIAN_FRONTEND=non-interactive apt-get install $package -y
    systemctl enable docker && systemctl start docker
fi


## Verify if docker is working
dockver=`docker --version`
if [ $? -eq 0 ];
  then
    echo "Exit status for $package command returned back with a successful exit code." && echo "Installed version is: $dockver"
  else
    echo "There was an issue with the execution of $package command." && echo -e
fi