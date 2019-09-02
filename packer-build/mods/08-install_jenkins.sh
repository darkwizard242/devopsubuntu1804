#!/bin/bash -e

# Shellcheck fixes for: SC2181

## Install jenkins
package="jenkins"

if dpkg -s $package &> /dev/null;
then
  echo -e "\n$package is already available and installed within the system."
else
  echo -e "\nAbout to install:\t$package"
  wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
  echo "deb http://pkg.jenkins.io/debian-stable binary/" > /etc/apt/sources.list.d/jenkins.list
  DEBIAN_FRONTEND=non-interactive apt-get update
  DEBIAN_FRONTEND=non-interactive apt-get install $package -y
  systemctl enable $package && systemctl start $package
fi


## Check service status of jenkins
if systemctl status $package --no-pager -l;
then
  echo -e && echo "$package is UP & Running"
else
  echo -e && echo "Service status for $package returned an error"
fi

echo -e "\nAdding user: jenkins to sudo group." && usermod -aG sudo jenkins
echo -e "\nAdding user: jenkins to docker group." && usermod -aG docker jenkins