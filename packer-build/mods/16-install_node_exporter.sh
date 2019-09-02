#!/bin/bash -e

# Shellcheck fixes for: SC2181, SC2034, SC2086, SC2006, SC2164

## Installing packages required for node_exporter
dependencies="wget tar"

for dependency in $dependencies;
do
  if dpkg -s "$dependency" &> /dev/null;
    then
      echo -e "\n$dependency is already available and installed within the system."
    else
      echo -e "About to install:\t$dependency."
      DEBIAN_FRONTEND=non-interactive apt-get install "$dependency" -y
  fi
done


## Download Node Exporter to support node_exporter and extract binary to /usr/local/bin
binary="node_exporter"
version="0.18.1"
osarch="linux-amd64"
extract_path="/usr/local/bin"
if [ -e $extract_path/$binary ]
then
  echo -e "\n$binary currently exists in:\t$extract_path"
else
  if id $binary &> /dev/null;
    then
      echo -e "\nThe user:\t$binary\tdoes exist.\n"
    else
      echo -e "\nThe user:\t$binary\tdoesn't exist. Creating user:\t$binary\t"
      useradd --no-create-home --shell /bin/false $binary
  fi
  if [ -d "/opt/$binary" ];
  then
    echo -e "\nDirectory:\t/opt/$binary\texists. About to remove it.\n"
    rm -rfv /opt/$binary
  else
    echo -e "\nDirectory:\t/opt/$binary\tdoesn't exist. Creating:\t/opt/$binary\t\n"
    mkdir -pv /opt/$binary
  fi
  echo -e "\nInstalling:\t${binary}!\n"
  wget -v -O /tmp/${binary}.tar.gz https://github.com/prometheus/${binary}/releases/download/v${version}/${binary}-${version}.${osarch}.tar.gz
  echo -e "\nExtracting: /tmp/${binary}.tar.gz \t to:\t /opt/$binary"
  tar -xzf /tmp/${binary}.tar.gz -C /opt/$binary --strip-components=1
  echo -e "\nRemoving:\t/tmp/${binary}.tar.gz" && rm -rv /tmp/${binary}.tar.gz
  echo -e "\nMoving binary files to:\t$extract_path\n"
  mv -v /opt/${binary}/${binary} $extract_path/
  echo -e "\nAssigning ownership of:\t/$extract_path/${binary}\n"
  chown -Rv ${binary}:${binary} $extract_path/${binary}
  echo -e "\nInstalled version is:\t$version\n"
  rm -rfv /opt/${binary}
  echo -e "\nCreating service for:\t$binary"
  cat <<EOF >/etc/systemd/system/${binary}.service
[Unit]
Description=Node_Exporter - Exporter for machine metrics.
After=network.target

[Service]
User=${binary}
Group=${binary}
Type=simple
ExecStart=/$extract_path/${binary}

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