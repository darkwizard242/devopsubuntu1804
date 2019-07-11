#!/bin/bash -eu


## Installing packages required for Terraform
dependencies="curl"

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


## Download Terraform and extract binary to /bin/
binary="aws-vault"
version="4.6.2"
osarch="linux-amd64"
if [ -e /usr/local/bin/aws-vault ]
then
  ver_existing=`$binary --version`
  echo "Terraform binary currently exists in /bin/ !"
  echo "Currently available version is: $ver_existing"
else
  curl -L -o /usr/local/bin/aws-vault https://github.com/99designs/${binary}/releases/download/v${version}/${binary}-${osarch}.zip
  unzip ${binary}_${version}_${osarch}.zip -d /bin/ && rm -r ${binary}_${version}_${osarch}.zip
  ver_fresh=`$binary --version`
  echo "Installed version is: $ver_fresh"
fi


sudo curl -L -o /usr/local/bin/aws-vault https://github.com/99designs/aws-vault/releases/download/v4.6.2/aws-vault-linux-amd64
echo -e "\n\nexport AWS_VAULT_BACKEND="file"" >> .bashrc
chmod -v 0755 /usr/local/bin/aws-vault