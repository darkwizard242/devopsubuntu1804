#!/bin/bash -eu


ms_key="https://packages.microsoft.com/keys/microsoft.asc"
azure_rel=`lsb_release -cs`
azure_repo="https://packages.microsoft.com/repos/azure-cli"

## Installing packages required for Azure CLI (commandline interface)
dependencies="curl apt-transport-https lsb-release gnupg"

for dependency in $dependencies;
do
  dpkg -s $dependency &> /dev/null && echo -e
  if [ $? -eq 0 ];
    then
      echo -e "\n$dependency is already available and installed within the system.\n"
    else
      echo -e "\nAbout to install $dependency.\n"
      DEBIAN_FRONTEND=non-interactive apt-get install $dependency -y
  fi
done

echo -e "\nAdding Microsoft Key!"
curl -sL $ms_key | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null

echo -e "\nAdding Azure Repo to apt list!"
echo "deb [arch=amd64] $azure_repo $azure_rel main" | tee /etc/apt/sources.list.d/azure-cli.list

echo -e "\nUpdating repo cache!"
apt-get update -y

## Installing Azure CLI
package="azure-cli"
dpkg -s $package &> /dev/null && echo -e
if [ $? -eq 0 ];
  then
    echo "$package is already available and installed within the system." && echo -e
  else
    echo -e "\nAbout to install $package."
    DEBIAN_FRONTEND=non-interactive apt-get install $package -y
fi