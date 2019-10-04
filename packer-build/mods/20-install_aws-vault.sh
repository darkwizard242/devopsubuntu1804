#!/bin/bash -eu

# Shellcheck fixes for: SC2181, SC2006, SC2140

## Installing packages required for aws-vault
dependencies="curl"

for dependency in $dependencies;
do
  if dpkg -s $dependency &> /dev/null;
    then
      echo -e "$dependency is already available and installed within the system."
    else
      echo -e "\nAbout to install:\t$dependency\n"
      DEBIAN_FRONTEND=non-interactive apt-get install "$dependency" -y
  fi
done


## Download aws-vault and extract binary to /bin/
binary="aws-vault"
version="4.6.2"
osarch="linux-amd64"
if [ -e /usr/local/bin/aws-vault ]
then
  ver_existing=$(${binary} --version)
  echo -e "\n$binary currently exists in:\t/usr/local/bin/"
  echo -e "\nCurrently available version is:\t$ver_existing"
else
  curl -L -o /usr/local/bin/aws-vault https://github.com/99designs/${binary}/releases/download/v${version}/${binary}-${osarch}
  echo -e "\n\nexport AWS_VAULT_BACKEND=\"file\"" >> .bashrc
  chmod -v 0755 /usr/local/bin/${binary}
  ver_fresh=$(${binary} --version)
  echo -e "\nInstalled version is:\t$ver_fresh"
fi
