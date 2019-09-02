#!/bin/bash -e

# Shellcheck fixes for: SC2181

sdk_rel="cloud-sdk-$(lsb_release -cs)"

# Add the Google Cloud SDK distribution URI as a package source
echo "deb http://packages.cloud.google.com/apt $sdk_rel main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

# Import the Google Cloud Platform public key
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

# Update the package list
apt-get update -y


## Installing Google Cloud SDK
package="google-cloud-sdk"
if dpkg -s $package &> /dev/null;
  then
    echo -e "\n$package is already available and installed within the system.\n"
  else
    echo -e "\nAbout to install:\t$package.\n"
    DEBIAN_FRONTEND=non-interactive apt-get install $package -y
fi