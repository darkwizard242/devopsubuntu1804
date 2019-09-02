#!/bin/bash

# Shellcheck fixes for: SC2181, SC2086, SC2164

## Installing packages required for Prometheus
dependencies="wget tar"

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


## Download Prometheus and extract binary to /usr/local/bin/
binary="prometheus"
version="2.10.0"
osarch="linux-amd64"
extract_path="/usr/local/bin"
if [ -e $extract_path/$binary ]
then
  ver_existing=$($binary --version)
  echo -e "\n$binary currently exists in:\t$extract_path"
else
  if id $binary &> /dev/null;
    then
      echo -e "\nThe user:\t$binary does exist.\n"
    else
      echo -e "The user: $binary does not exist. Creating user:\t$binary\n"
      useradd --no-create-home --shell /bin/false $binary
  fi
  mkdir -pv /etc/$binary /var/lib/$binary
  chown -v $binary:$binary /var/lib/$binary
  echo -e "\nInstalling:\t${binary}"
  if [ -d "/opt/$binary" ];
  then
    echo -e "\nDirectory:\t/opt/$binary exists. About to remove it.\n"
    rm -rfv /opt/$binary
  else
    echo -e "\nDirectory:\t/opt/$binary doesn't exist. Creating: \t/opt/$binary\n"
    mkdir -pv /opt/$binary
  fi
  wget -v -O /tmp/${binary}.tar.gz https://github.com/${binary}/${binary}/releases/download/v${version}/${binary}-${version}.${osarch}.tar.gz
  echo -e "\nExtracting: /tmp/${binary}.tar.gz \t to:\t /opt/$binary"
  tar -xzf /tmp/${binary}.tar.gz -C /opt/$binary --strip-components=1
  echo -e "\nRemoving: /tmp/${binary}.tar.gz" && rm -rv /tmp/${binary}.tar.gz
  rm -v /opt/${binary}/${binary}.yml
  cat <<EOF >/opt/${binary}/${binary}.yml
global:
  scrape_interval:     5s
  evaluation_interval: 5s

# rule_files:
#   - "rules.yml"

alerting:
  alertmanagers:
  - static_configs:
    - targets:
      - localhost:9093

scrape_configs:
  - job_name: 'node'
    static_configs:
    - targets: ['localhost:9100']
  - job_name: 'prometheus'
    static_configs:
    - targets: ['localhost:9090']
  - job_name: 'alertmanager'
    static_configs:
    - targets: ['localhost:9093']
  # - job_name: 'cadvisor'
  #   static_configs:
  #   - targets: ['localhost:8000']
EOF
  echo -e "\nMoving binary files to $extract_path\n"
  mv -v /opt/${binary}/${binary} /opt/${binary}/promtool $extract_path/
  echo -e "\nMoving console dir(s) & ${binary}.yml /etc/${binary}\n"
  mv -v /opt/${binary}/console* /opt/${binary}/${binary}.yml /etc/${binary}/
  echo -e "\nAssigning ownership of $extract_path/${binary} & /usr/local/bin/promtool to ${binary}\n"
  chown -Rv ${binary}:${binary} $extract_path/${binary} $extract_path/promtool
  echo -e "\nAssigning ownership of /etc/${binary} to ${binary}\n"
  chown -Rv ${binary}:${binary} /etc/${binary}
  echo -e "\nAssigning ownership of /var/lib/${binary} to ${binary}\n"
  chown -Rv ${binary}:${binary} /var/lib/${binary}
  echo -e "\nRemoving temporary ${binary} directory from /opt"
  rm -rfv /opt/${binary}
  cat <<EOF >/etc/systemd/system/${binary}.service
[Unit]
Description=Prometheus - monitoring system and time series database.
Wants=network-online.target
After=network-online.target

[Service]
User=${binary}
Group=${binary}
Type=simple
ExecStart=$extract_path/${binary} \
    --config.file /etc/${binary}/${binary}.yml \
    --storage.tsdb.path /var/lib/${binary}/ \
    --web.console.templates=/etc/${binary}/consoles \
    --web.console.libraries=/etc/${binary}/console_libraries

[Install]
WantedBy=multi-user.target

EOF
  echo -e "\nPerforming systemctl daemon reload."
  systemctl daemon-reload
  echo -e "\nEnabling systemctl service for:\t${binary}"
  systemctl enable ${binary}.service
  echo -e "\nStarting systemctl service for:\t${binary}"
  systemctl start ${binary}.service
fi
