#!/bin/bash

## Installing packages required for node_exporter
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


## Download Node Exporter to support node_exporter and extract binary to /bin/
binary="node_exporter"
version="0.18.1"
osarch="linux-amd64"
if [ -e /bin/node_exporter ]
then
  ver_existing=`$binary --version`
  echo "node_exporter binary currently exists in /bin/ !"
else
  echo -e "\nInstalling ${binary}!\n"
  cd /opt/
  wget -v https://github.com/prometheus/${binary}/releases/download/v${version}/${binary}-${version}.${osarch}.tar.gz
  tar -xzf ${binary}-${version}.${osarch}.tar.gz && rm -r ${binary}-${version}.${osarch}.tar.gz
  cd /opt/${binary}-${version}.${osarch}
  cp -v /opt/${binary}-${version}.${osarch}/${binary} /bin/
  echo -e "\nInstalled version is: $version"
  echo -e "\nCreating service for node_exporter"
  cat <<EOF >/etc/systemd/system/${binary}.service
[Unit]
Description=Node_Exporter - Exporter for machine metrics.
After=network.target

[Service]
User=root
Group=root
Type=simple
ExecStart=/bin/${binary}

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