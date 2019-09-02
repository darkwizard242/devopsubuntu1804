#!/bin/bash -e

# Shellcheck fixes for: SC2181, SC2028

## Install Ruby
packages="ruby"

for package in $packages;
do
  if dpkg -s $package &> /dev/null;
    then
      echo -e "\n$package is already available and installed within the system.\n"
    else
      echo -e "\nAbout to install:\t$package\n"
      DEBIAN_FRONTEND=non-interactive apt-get install $package -y
  fi
done

## Install ServerSpec
gems_to_install="serverspec"
if which ruby;
then
  echo -e "\nInstalling ruby gem: $gems_to_install.\n" 
  gem install $gems_to_install
else
  echo -e "\nRuby is not installed.\n"
fi
