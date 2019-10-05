#!/bin/bash

# Shellcheck fixes for: SC2181, SC2086, SC2164, SC2028, SC2034, SC2161

## Installing packages required for alertmanager
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


## Download AlertManager to support alertmanager and extract binary to /bin/
binary="alertmanager"
version="0.19.0"
osarch="linux-amd64"
extract_path="/usr/local/bin"
if [ -e $extract_path/$binary ]
then
  ver_existing=$($binary --version)
  echo -e "\n$binary currently exists in:\t$extract_path"
else
  if id $binary &> /dev/null;
    then
      echo -e "\nThe user:\t$binary\tdoes exist.\n"
    else
      echo -e "\nThe user:\t$binary\tdoesn't exist. Creating user:\t$binary\t"
      useradd --no-create-home --shell /bin/false $binary
  fi
  mkdir -pv /etc/$binary
  echo -e "\nInstalling:\t${binary}!\n"
  wget -v -O /tmp/${binary}.tar.gz https://github.com/prometheus/${binary}/releases/download/v${version}/${binary}-${version}.${osarch}.tar.gz
  if [ -d "/opt/$binary" ];
  then
    echo -e "\nDirectory: /opt/$binary exists. About to remove it.\n"
    rm -rfv /opt/$binary
  else
    echo -e "\nDirectory: /opt/$binary doesn't exist. Creating /opt/$binary !\n"
    mkdir -pv /opt/$binary
  fi
  echo -e "\nExtracting: /tmp/${binary}.tar.gz \t to:\t /opt/$binary"
  tar -xzf /tmp/${binary}.tar.gz -C /opt/$binary --strip-components=1
  echo -e "\nRemoving:\t/tmp/${binary}.tar.gz" && rm -rv /tmp/${binary}.tar.gz
  echo -e "\nMoving binary files to $extract_path\n"
  mv -v /opt/${binary}/${binary} /opt/${binary}/amtool $extract_path
  echo -e "\nMoving console dir(s) & ${binary}.yml /etc/${binary}\n"
  mv -v /opt/${binary}/${binary}.yml /etc/${binary}/
  echo -e "\nAssigning ownership of $extract_path/${binary} & $extract_path/promtool to ${binary}\n"
  chown -Rv ${binary}:${binary} /usr/local/bin/${binary} /usr/local/bin/amtool
  echo -e "\nAssigning ownership of /etc/${binary} to ${binary}\n"
  chown -Rv ${binary}:${binary} /etc/${binary}
  echo -e "\nRemoving temporary ${binary} directory from /opt"
  rm -rfv /opt/${binary}
  echo -e "\nCreating service for ${binary}"
  cat <<EOF >/etc/systemd/system/${binary}.service
[Unit]
Description=Alertmanager - Manages Alerting based on rules.
Wants=network-online.target
After=network-online.target

[Service]
User=${binary}
Group=${binary}
Type=simple
WorkingDirectory=/etc/${binary}/
ExecStart=/usr/local/bin/${binary} \
    --config.file=/etc/${binary}/${binary}.yml

[Install]
WantedBy=multi-user.target

EOF
  echo -e "\nPerforming systemctl daemon reload."
  systemctl daemon-reload
  echo -e "\nEnabling systemctl service for ${binary}."
  systemctl enable ${binary}.service
  echo -e "\nStarting systemctl service for ${binary}.\n"
  systemctl start ${binary}.service
fi
