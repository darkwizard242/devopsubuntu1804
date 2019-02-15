#/bin/bash -eux


## Install jenkins
package="jenkins"

dpkg -s $package &> /dev/null && echo -e
if [ $? -eq 0 ];
then
  echo "$package is already available and installed within the system" && echo -e
else
  echo "About to install $package" && echo -e
  wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
  sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
  apt-get install $package -y
fi


## Check service status of jenkins
systemctl status jenkins --no-pager -l
if [ $? -eq 0 ];
then
  echo -e && echo "$package is UP & Running"
else
  echo -e && echo "Service status for $package returned an error"
fi
