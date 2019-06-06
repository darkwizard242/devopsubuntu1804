#!/bin/bash -eu

## Install Ruby
packages="ruby"

for package in $packages;
do
  dpkg -s $package &> /dev/null && echo -e
  if [ $? -eq 0 ];
    then
      echo "$package is already available and installed within the system" && echo -e
    else
      echo "About to install $package" && echo -e
      DEBIAN_FRONTEND=non-interactive apt-get install $package -y
  fi
done

## Install ServerSpec
gems_to_install="serverspec"
ruby --version
if [ $? -eq 0 ];
then
  echo "Installing $gems_to_install" 
  gem install $gems_to_install
else
  echo "Ruby is not installed."
fi
