#!/bin/bash -eu


sdk_rel="cloud-sdk-$(lsb_release -cs)"

# Add the Google Cloud SDK distribution URI as a package source
echo "deb http://packages.cloud.google.com/apt $sdk_rel main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

# Import the Google Cloud Platform public key
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

# Update the package list
apt-get update -y


## Installing Google Cloud SDK
package="google-cloud-sdk"
dpkg -s $package &> /dev/null && echo -e
if [ $? -eq 0 ];
  then
    echo "$package is already available and installed within the system." && echo -e
  else
    echo -e "\nAbout to install $package."
    DEBIAN_FRONTEND=non-interactive apt-get install $package -y
fi