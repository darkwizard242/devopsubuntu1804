#/bin/bash -eux


## Installing packages required for ansible
dependencies="software-properties-common python python3 python3-pip"

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

## Adding apt repository for ansible
apt-add-repository ppa:ansible/ansible -y


## Installing ansible
package="ansible"
dpkg -s $package &> /dev/null && echo -e
if [ $? -eq 0 ];
  then
    echo "$package is already available and installed within the system." && echo -e
  else
    echo "About to install $package." && echo -e
    apt-get install $package -y
fi


## Verify if ansible is working
ansible localhost -m shell -a "hostname"
if [ $? -eq 0 ];
  then
    echo "Exit status for Ansible command returned back with a successful exit code." && echo -e
  else
    echo "There was an issue with the execution of ansible command." && echo -e
fi
