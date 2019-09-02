#!/bin/bash -e

# Shellcheck fixes for: SC2086, SC2181

## Installing packages required for ansible
dependencies="software-properties-common python3 python3-pip"

for dependency in $dependencies;
do
  if dpkg -s "$dependency" &> /dev/null;
    then
      echo -e "\n$dependency is already available and installed within the system."
    else
      echo -e "About to install:\t$dependency."
      DEBIAN_FRONTEND=non-interactive apt-get install "$dependency" -y
  fi
done


## Installing ansible
package="ansible"
if dpkg -s $package &> /dev/null;
  then
    echo -e "\n$package is already available and installed within the system."
  else
    apt-add-repository ppa:ansible/ansible -y
    DEBIAN_FRONTEND=non-interactive apt-get update
    echo -e "About to install:\t$package.\n"
    DEBIAN_FRONTEND=non-interactive apt-get install $package -y
fi


## Verify if ansible is working
if ansible localhost -m shell -a "hostname";
  then
    echo -e "\nExit status for Ansible command returned back with a successful exit code."
  else
    echo -e "\nThere was an issue with the execution of ansible command." && echo -e
fi
