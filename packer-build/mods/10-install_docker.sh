#!/bin/bash -e

# Shellcheck fixes for: SC2086, SC2181, SC2006

## Installing packages required for docker-ce
dependencies="apt-transport-https ca-certificates curl software-properties-common"

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


## Installing docker-ce
system_rel=$(lsb_release -cs)
package="docker-ce docker-ce-cli containerd.io"
if dpkg -s $package &> /dev/null;
  then
    echo -e "\n$package is already available and installed within the system."
  else
    echo -e "\nAbout to install:\t$package."
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
    echo -e "\nCreating docker repo file."
    echo -e "deb [arch=amd64] https://download.docker.com/linux/ubuntu $system_rel stable"  > /etc/apt/sources.list.d/docker.list
    DEBIAN_FRONTEND=non-interactive apt-get update
    DEBIAN_FRONTEND=non-interactive apt-get install $package -y
fi

echo -e "\nEnabling and starting docker service." && systemctl enable docker && systemctl start docker

## Verify if docker is working
dockver=$(docker --version)

if docker --version;
  then
    echo -e "\nExit status for $package command returned back with a successful exit code."
    echo -e "\nInstalled version is:\t$dockver"
  else
    echo -e "\nThere was an issue with the execution of $package command."
fi
