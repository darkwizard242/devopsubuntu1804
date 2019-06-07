#!/bin/bash

## Installing packages required for Grafana
dependencies="wget tar"

for dependency in $dependencies;
do
  dpkg -s $dependency &> /dev/null && echo -e
  if [ $? -eq 0 ];
    then
      echo "$dependency is already available and installed within the system." && echo -e
    else
      echo "About to install $dependency." && echo -e
      DEBIAN_FRONTEND=non-interactive apt-get install $dependency -y
  fi
done


## Download Grafana and extract binary to /bin/
binary="grafana"
version="6.2.2"
osarch="linux-amd64"
if [ -e /bin/grafana ]
then
  echo "Grafana binary currently exists in /bin/ !"
else
  echo -e "\nInstalling ${binary}!\n"
  cd /opt/
  wget -v https://dl.${binary}.com/oss/release/${binary}-${version}.${osarch}.tar.gz
  tar -xzf ${binary}-${version}.${osarch}.tar.gz && rm -r ${binary}-${version}.${osarch}.tar.gz
  cd /opt/${binary}-${version}
  cp -v /opt/${binary}-${version}/bin/${binary}-server /bin/
  echo -e "\nInstalled version is: $version"
  cat <<EOF >/etc/systemd/system/${binary}.service
[Unit]
Description=Grafana - analytics platform for all your metrics.
After=network.target

[Service]
User=root
Group=root
Type=simple
ExecStart=/bin/${binary}-server -homepath /opt/${binary}-${version} -config /opt/${binary}-${version}/conf/defaults.ini

[Install]
WantedBy=multi-user.target
EOF
  echo -e "Performing systemctl daemon reload."
  systemctl daemon-reload
  echo -e "Enabling systemctl service for ${binary}."
  systemctl enable ${binary}.service
  echo -e "Starting systemctl service for ${binary}."
  systemctl start ${binary}.service
  echo -e "\n\n\n\n"
fi
