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
if [ -e /usr/local/bin/node_exporter ]
then
  ver_existing=`$binary --version`
  echo "node_exporter binary currently exists in /bin/ !"
else
  id $binary &> /dev/null && echo -e
  if [ $? -eq 0 ];
    then
      echo "The user: $binary does exist." && echo -e
    else
      echo "The user: $binary does not exist. Creating user: $binary !"
      useradd --no-create-home --shell /bin/false $binary
  fi
  echo -e "\nInstalling ${binary}!\n"
  cd /opt/
  wget -v https://github.com/prometheus/${binary}/releases/download/v${version}/${binary}-${version}.${osarch}.tar.gz
  if [ -d "/opt/$binary" ];
  then
    echo -e "\nDirectory: /opt/$binary exists. About to remove it.\n"
    rm -rfv /opt/$binary
  else
    echo -e "\nDirectory: /opt/$binary doesn't exist. Creating /opt/$binary !\n"
    mkdir -pv /opt/$binary
  fi
  tar -xzf ${binary}-${version}.${osarch}.tar.gz -C /opt/$binary --strip-components=1 && rm -r ${binary}-${version}.${osarch}.tar.gz
  cd /opt/${binary}
  echo -e "\nMoving binary files to /usr/local/bin\n"
  mv -v /opt/${binary}/${binary} /usr/local/bin/
  echo -e "\nAssigning ownership of /usr/local/bin/${binary}\n"
  chown -Rv ${binary}:${binary} /usr/local/bin/${binary}
  echo -e "\nInstalled version is: $version"
  rm -rfv /opt/${binary}
  echo -e "\nCreating service for node_exporter"
  cat <<EOF >/etc/systemd/system/${binary}.service
[Unit]
Description=Node_Exporter - Exporter for machine metrics.
After=network.target

[Service]
User=${binary}
Group=${binary}
Type=simple
ExecStart=/usr/local/bin/${binary}

[Install]
WantedBy=multi-user.target
EOF
  echo -e "\nPerforming systemctl daemon reload."
  systemctl daemon-reload
  echo -e "\nEnabling systemctl service for ${binary}."
  systemctl enable ${binary}.service
  echo -e "\nStarting systemctl service for ${binary}.\n"
  systemctl start ${binary}.service
  echo -e "\n"
fi