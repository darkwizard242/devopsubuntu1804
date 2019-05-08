#!/bin/bash -eu


## Create groups.
listOfGroups="docker jenkins ansible"
for groupname in $listOfGroups
do
        egrep -i "^$groupname" /etc/group &> /dev/null
        if [ $? -eq 0 ];
    then
      echo "The group: $groupname does exist." && echo -e
    else
      echo "The group: $groupname doesn't exist. Creating group: $groupname !" && echo -e
      groupadd -r $groupname
  fi
done

## Create users.
listOfUsers="docker ansible"
for username in $listOfUsers;
do
  id $username &> /dev/null && echo -e
  if [ $? -eq 0 ];
    then
      echo "The user: $username does exist." && echo -e
      usermod -aG docker $username
    else
      echo "The user: $username does not exist. Creating user: $username !"
      useradd $username -m -s /bin/bash -p $(openssl passwd -1 password) -g $username
      echo -e "Adding user: $username to sudo group." && usermod -aG sudo $username
      echo -e "Adding user: $username to docker group." && usermod -aG docker $username
      echo -e
  fi
done