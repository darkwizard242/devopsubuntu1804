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
if [ -e /usr/local/bin/prometheus ]
then
  echo "Prometheus binary currently exists in /bin/ !"
else
  id $binary &> /dev/null && echo -e
  if [ $? -eq 0 ];
    then
      echo "The user: $binary does exist." && echo -e
    else
      echo "The user: $binary does not exist. Creating user: $binary !"
      useradd --no-create-home --shell /bin/false $binary
  fi
  mkdir -pv /etc/$binary /var/lib/$binary
  chown -v $binary:$binary /var/lib/$binary
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
  echo -e "\nMoving binary files to /usr/local/bin\n"
  mv -v /opt/${binary}/${binary} /opt/${binary}/promtool /usr/local/bin/
  echo -e "\nMoving console dir(s) & ${binary}.yml /etc/${binary}\n"
  mv -v /opt/${binary}/console* /opt/${binary}/${binary}.yml /etc/${binary}/
  echo -e "\nAssigning ownership of /usr/local/bin/${binary} & /usr/local/bin/promtool to ${binary}\n"
  chown -Rv ${binary}:${binary} /usr/local/bin/${binary} /usr/local/bin/promtool
  echo -e "\nAssigning ownership of /etc/${binary} to ${binary}\n"
  chown -Rv ${binary}:${binary} /etc/${binary}
  echo -e "\nAssigning ownership of /var/lib/${binary} to ${binary}\n"
  chown -Rv ${binary}:${binary} /var/lib/${binary}
  echo -e "\nRemoving temporary ${binary} directory from /opt"
  rm -rfv /opt/${binary}
  echo -e "\nInstalled version is: $version"
  cat <<EOF >/etc/systemd/system/${binary}.service
[Unit]
Description=Prometheus - monitoring system and time series database.
Wants=network-online.target
After=network-online.target

[Service]
User=${binary}
Group=${binary}
Type=simple
ExecStart=/usr/local/bin/${binary} \
    --config.file /etc/${binary}/${binary}.yml \
    --storage.tsdb.path /var/lib/${binary}/ \
    --web.console.templates=/etc/${binary}/consoles \
    --web.console.libraries=/etc/${binary}/console_libraries

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
