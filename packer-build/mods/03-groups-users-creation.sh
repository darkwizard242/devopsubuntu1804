#!/bin/bash -eu


# Shellcheck fixes for: SC2196, SC2181, SC2086, SC2046

## Create groups.
listOfGroups="docker jenkins ansible"
for groupname in $listOfGroups
do
  if grep -Ei "^$groupname" /etc/group &> /dev/null;
    then
      echo -e "\nThe group: $groupname does exist."
    else
      echo -e "\nThe group: $groupname doesn't exist. Creating group:\t$groupname"
      groupadd -r "$groupname"
  fi
done

## Create users.
listOfUsers="docker ansible"
for username in $listOfUsers;
do
  if id "$username" &> /dev/null;
    then
      echo -e "\nThe user: $username does exist."
      usermod -aG docker "$username"
    else
      echo -e "\nThe user: $username does not exist. Creating user: $username !"
      useradd "$username" -m -s /bin/bash -p "$(openssl passwd -1 password)" -g "$username"
      echo -e "\nAdding user: $username to sudo group." && usermod -aG sudo "$username"
      echo -e "\nAdding user: $username to docker group." && usermod -aG docker "$username"
  fi
done