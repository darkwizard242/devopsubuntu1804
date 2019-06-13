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
  cp -v /opt/${binary}/bin/${binary}-server /usr/local/bin/
  echo -e "\nInstalled version is: $version"
  cat <<EOF >/etc/systemd/system/${binary}.service
[Unit]
Description=Grafana - analytics platform for all your metrics.
After=network.target

[Service]
User=root
Group=root
Type=simple
ExecStart=/usr/local/bin/${binary}-server -homepath /opt/${binary} -config /opt/${binary}/conf/defaults.ini

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
