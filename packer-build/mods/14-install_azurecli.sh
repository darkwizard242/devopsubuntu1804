#!/bin/bash -e

# Shellcheck fixes for: SC2181, SC2028, SC2006

ms_key="https://packages.microsoft.com/keys/microsoft.asc"
azure_rel=$(lsb_release -cs)
azure_repo="https://packages.microsoft.com/repos/azure-cli"

## Installing packages required for Azure CLI (commandline interface)
dependencies="curl apt-transport-https lsb-release gnupg"

for dependency in $dependencies;
do
  if dpkg -s "$dependency" &> /dev/null;
    then
      echo -e "\n$dependency is already available and installed within the system.\n"
    else
      echo -e "\nAbout to install:\t$dependency.\n"
      DEBIAN_FRONTEND=non-interactive apt-get install "$dependency" -y
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
if dpkg -s $package &> /dev/null;
  then
    echo -e "\n$package is already available and installed within the system.\n"
  else
    echo -e "\nAbout to install:\t$package."
    DEBIAN_FRONTEND=non-interactive apt-get install $package -y
fi