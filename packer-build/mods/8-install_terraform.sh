#/bin/bash -eux


## Installing packages required for Terraform
dependencies="wget unzip"

for dependency in $dependencies;
do
  dpkg -s $dependency &> /dev/null && echo -e
  if [ $? -eq 0 ];
    then
      echo "$dependency is already available and installed within the system." && echo -e
    else
      echo "About to install $dependency." && echo -e
      apt-get install $dependency -y
  fi
done


## Download terraform and extract binary to /bin/
binary="terraform"
version="0.11.11"
osarch="linux_amd64"
if [ -e /bin/terraform ]
then
  ver_existing=`$binary --version`
  echo "Terraform binary currently exists in /bin/ !"
  echo "Currently available version is: $ver_existing"
else
  wget https://releases.hashicorp.com/${binary}/${version}/${binary}_${version}_${osarch}.zip
  unzip ${binary}_${version}_${osarch}.zip -d /bin/ && rm -r ${binary}_${version}_${osarch}.zip
  ver_fresh=`$binary --version`
  echo "Installed version is: $ver_fresh"
fi
