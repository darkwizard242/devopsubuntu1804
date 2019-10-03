#!/bin/bash -e

# Shellcheck fixes for: SC2034

# SETTING VARIABLES
dependencies="curl wget jq"
binary="osquery"
binaryinteractive="osqueryi"
binaryservice="osqueryd"
version="4.0.2"
osarch="linux.amd64"
pathtointeractivebinary="/usr/bin/${binaryinteractive}"


## Installing packages required for $binary
for dependency in $dependencies;
do
  if dpkg -s "$dependency" &> /dev/null;
    then
      echo -e "\n$dependency is already available and installed within the system."
    else
      echo -e "\nAbout to install:\t$dependency."
      DEBIAN_FRONTEND=non-interactive apt-get install "$dependency" -y
  fi
done


## Download and install/configure osquery.
if [ -e ${pathtointeractivebinary} ]
then
  ver_existing=$(${pathtointeractivebinary} --version | awk '{print $3}')
  echo -e "\nInteractive $binary currently exists in:\t/usr/bin/"
  echo -e "\nCurrently available version is:\t$ver_existing"
else
  wget -v -O /tmp/${binary}.deb https://pkg.${binary}.io/deb/${binary}_${version}_1.${osarch}.deb
  dpkg -i /tmp/${binary}.deb
  echo -e "\nRemoving the .deb file for ${binary}."
  rm -v /tmp/${binary}.deb
  echo -e "\nCreating configuration file for ${binary} in /etc/${binary} as /etc/${binary}/${binary}.conf ."
  cp -v /usr/share/${binary}/${binary}.example.conf /etc/${binary}/${binary}.conf
  ver_fresh=$(${pathtointeractivebinary} --version | awk '{print $3}')
  echo -e "\nInstalled version is:\t$ver_fresh"
  echo -e "\nPerforming systemctl daemon reload."
  systemctl daemon-reload
  echo -e "\nEnabling systemctl service for:\t${binaryservice}"
  systemctl enable ${binaryservice}.service
  echo -e "\nStarting systemctl service for:\t${binaryservice}"
  systemctl start ${binaryservice}.service
fi

#______________________________________________________________________________________________________________________________#
## SAMPLE SQL queries for osqueryi - DEBIAN/UBUNTU system based

# 1. Fetch data in json format and parse to jq. SELECT STATEMENT to retrieve data for following columns against processes table in Descending order based upon the total_size column:
# Columns Fetched are:
# - pid
# - name
# - state
# - total_size (total_size contains data in bytes which is converted to MB's by dividing the value with 1024*1024)
# SQL QUERY: osqueryi --json "SELECT pid,name,state,total_size/(1024*1024) FROM processes ORDER by total_size DESC" | jq  -r '.[0]'


# 2. Fetch data in json format and parse to jq. SELECT STATEMENT to retrieve data for all columns against os_version:
# SQL QUERY: osqueryi --json "SELECT * FROM os_version" | jq


# 3. Fetch data in json format and parse to jq. SELECT STATEMENT to retrieve data for following columns against listening_ports table where port is equal to 8080:
# Columns Fetched are:
# - pid
# - port
# - protocol
# SQL QUERY: osqueryi --json "SELECT pid,port,protocol FROM listening_ports WHERE port=8080" | jq

# 4. Fetch data in json format and parse to jq. SELECT STATEMENT to retrieve data for all columns against etc_hosts:
# SQL QUERY: osqueryi --json "SELECT * FROM etc_hosts" | jq


# 5. Fetch data in json format and parse to jq. SELECT STATEMENT to retrieve data all columns against deb_packages table name of package is equal to osquery:
# SQL QUERY: osqueryi --json "SELECT * from deb_packages WHERE name='osquery'" | jq


# 6. Fetch data in json format and parse to jq. SELECT STATEMENT to retrieve data for all columns against crontab:
# SQL QUERY: osqueryi --json "SELECT * FROM crontab" | jq


# 7. Fetch data in json format and parse to jq. SELECT STATEMENT to retrieve data for all columns against file where path is /etc/hosts:
# SQL QUERY: osqueryi --json "SELECT * from file where path='/etc/hosts'" | jq


# 8. Fetch data in json format and parse to jq. SELECT STATEMENT to retrieve data for all columns against logged_in_users:
# SQL QUERY: osqueryi --json "SELECT * from logged_in_users" | jq

#______________________________________________________________________________________________________________________________#

