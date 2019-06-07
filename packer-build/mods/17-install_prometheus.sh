#!/bin/bash

## Installing packages required for Prometheus
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


## Download Prometheus and extract binary to /bin/
binary="prometheus"
version="2.10.0"
osarch="linux-amd64"
if [ -e /bin/prometheus ]
then
  echo "Prometheus binary currently exists in /bin/ !"
else
  echo -e "\nInstalling ${binary}!\n"
  cd /opt/
  wget -v https://github.com/${binary}/${binary}/releases/download/v${version}/${binary}-${version}.${osarch}.tar.gz
  tar -xzf ${binary}-${version}.${osarch}.tar.gz && rm -r ${binary}-${version}.${osarch}.tar.gz
  cd /opt/${binary}-${version}.${osarch}
  rm -v /opt/${binary}-${version}.${osarch}/${binary}.yml
  cat <<EOF >/opt/${binary}-${version}.${osarch}/${binary}.yml
  global:
    scrape_interval:     5s # Set the scrape interval to every 5 seconds. Default is every 1 minute.
    evaluation_interval: 5s # Evaluate rules every 5 seconds. The default is every 1 minute.
  scrape_configs:
    - job_name: 'node'
      static_configs:
      - targets: ['localhost:9100']
    - job_name: 'prometheus'
      static_configs:
      - targets: ['localhost:9090']
EOF
  cp -v /opt/${binary}-${version}.${osarch}/${binary} /bin/
  echo -e "\nInstalled version is: $version"
  cat <<EOF >/etc/systemd/system/${binary}.service
[Unit]
Description=Prometheus - monitoring system and time series database.
After=network.target

[Service]
User=root
Group=root
Type=simple
ExecStart=/bin/${binary} --config.file=/opt/${binary}-${version}.${osarch}/${binary}.yml

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
  #echo -e "\nExecuting PROMETHEUS now!\n!!"
  #/bin/prometheus --config.file=/opt/${binary}-${version}.${osarch}/${binary}.yml > /dev/null 2>&1 &
fi
