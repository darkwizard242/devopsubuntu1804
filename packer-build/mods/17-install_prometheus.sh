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
  if [ -d "/opt/$binary" ];
  then
    echo -e "Directory: /opt/$binary exists. About to remove it."
    rm -rfv /opt/$binary
  else
    echo -e "\nDirectory: /opt/$binary doesn't exist. Creating /opt/$binary !\n"
    mkdir -pv /opt/$binary
  fi
  tar -xzf ${binary}-${version}.${osarch}.tar.gz -C /opt/$binary --strip-components=1 && rm -r ${binary}-${version}.${osarch}.tar.gz
  cd /opt/${binary}
  rm -v /opt/${binary}/${binary}.yml
  cat <<EOF >/opt/${binary}/${binary}.yml
global:
  scrape_interval:     5s
  evaluation_interval: 5s

# rule_files:
#   - "rules.yml"

# alerting:
#   alertmanagers:
#   - static_configs:
#     - targets:
#       - localhost:9093

scrape_configs:
  - job_name: 'node'
    static_configs:
    - targets: ['localhost:9100']
  - job_name: 'prometheus'
    static_configs:
    - targets: ['localhost:9090']
  # - job_name: 'alertmanager'
  #   static_configs:
  #   - targets: ['localhost:9093']
EOF
  cp -v /opt/${binary}/${binary} /usr/local/bin/
  echo -e "\nInstalled version is: $version"
  cat <<EOF >/etc/systemd/system/${binary}.service
[Unit]
Description=Prometheus - monitoring system and time series database.
After=network.target

[Service]
User=root
Group=root
Type=simple
ExecStart=/usr/local/bin/${binary} --config.file=/opt/${binary}/${binary}.yml

[Install]
WantedBy=multi-user.target
EOF
  echo -e "\nPerforming systemctl daemon reload.\n"
  systemctl daemon-reload
  echo -e "\nEnabling systemctl service for ${binary}.\n"
  systemctl enable ${binary}.service
  echo -e "\nStarting systemctl service for ${binary}.\n"
  systemctl start ${binary}.service
  echo -e "\n"
  #echo -e "\nExecuting PROMETHEUS now!\n!!"
  #/bin/prometheus --config.file=/opt/${binary}-${version}.${osarch}/${binary}.yml > /dev/null 2>&1 &
fi
