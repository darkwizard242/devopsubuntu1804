#!/bin/bash

# Shellcheck fixes for: SC2181, SC2164

dependencies="wget tar git"
servername=$(hostname -f)
binary="gogs"
version="0.11.91"
osarch="linux_amd64"
pathtobinary="/opt/${binary}"
pathtobinaryrepos="${pathtobinary}/repositories"
binaryport="3005"

## Installing packages required for $binary
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



## Download Gogs and setup/configure.

if [ -e /opt/${binary}/${binary} ]
then
  echo -e "${binary} currently exists in:\t/opt/${binary}/"
else
  if id $binary &> /dev/null;
    then
      echo -e "\nThe user:\t$binary does exist."
    else
      echo -e "\nThe user:\t$binary does not exist. Creating user:\t$binary"
      useradd --no-create-home --shell /bin/false $binary
  fi
  echo -e "\nInstalling:\t${binary}!\n"
  wget -v -O /tmp/${binary}.tar.gz https://dl.${binary}.io/${version}/${binary}_${version}_${osarch}.tar.gz
  if [ -d "$pathtobinary" ];
  then
    echo -e "\nDirectory:\t$pathtobinary exists. About to remove it.\n"
    rm -rfv "$pathtobinary"
  else
    echo -e "\nDirectory:\t$pathtobinary doesn't exist. Creating:\t$pathtobinary\n"
    mkdir -pv "$pathtobinary"
  fi
  if [ -d "$pathtobinaryrepos" ];
  then
    echo -e "\nDirectory:\t$pathtobinaryrepos exists. About to remove it.\n"
    rm -rfv "$pathtobinaryrepos"
  else
    echo -e "\nDirectory:\t$pathtobinary doesn't exist. Creating:\t$pathtobinaryrepos\n"
    mkdir -pv "$pathtobinaryrepos"
  fi
  tar -xzf /tmp/${binary}.tar.gz -C "$pathtobinary" --strip-components=1
  echo -e "\nRemoving:\t/tmp/${binary}.tar.gz" && rm -rv /tmp/${binary}.tar.gz
  mkdir -pv "$pathtobinary"/custom/conf/
  cat <<EOF >"$pathtobinary"/custom/conf/app.ini
PP_NAME = Repository Manager
RUN_USER = ${binary}
RUN_MODE = prod

[database]
DB_TYPE  = sqlite3
HOST     = 127.0.0.1:3306
NAME     = gogs
USER     = ${binary}
PASSWD   =
SSL_MODE = disable
PATH     = data/gogs.db

[repository]
ROOT = $pathtobinaryrepos

[server]
DOMAIN           = ${servername}
HTTP_PORT        = $binaryport
ROOT_URL         = http://${servername}:$binaryport/
DISABLE_SSH      = false
SSH_PORT         = 2203
START_SSH_SERVER = true
OFFLINE_MODE     = true

[mailer]
ENABLED = false

[service]
REGISTER_EMAIL_CONFIRM = false
ENABLE_NOTIFY_MAIL     = false
DISABLE_REGISTRATION   = false
ENABLE_CAPTCHA         = true
REQUIRE_SIGNIN_VIEW    = false

[picture]
DISABLE_GRAVATAR        = false
ENABLE_FEDERATED_AVATAR = false

[session]
PROVIDER = file

[log]
MODE      = console, file
LEVEL     = Info
ROOT_PATH = $pathtobinary/log

[security]
INSTALL_LOCK = true
SECRET_KEY   = JPOSWwnjJZ8wmgo
EOF
  echo -e "\nAssigning ownership of $pathtobinary\n"
  chown -R ${binary}:${binary} "$pathtobinary"
  echo -e "\nCreating service for ${binary}"
  cat <<EOF >/etc/systemd/system/${binary}.service
[Unit]
Description=Gogs
Wants=network-online.target
After=network-online.target
# After=mariadb.service mysqld.service postgresql.service memcached.service redis.service

[Service]
# Modify these two values and uncomment them if you have
# repos with lots of files and get an HTTP error 500 because
# of that
###
#LimitMEMLOCK=infinity
#LimitNOFILE=65535
Type=simple
User=${binary}
Group=${binary}
WorkingDirectory=$pathtobinary
ExecStart=$pathtobinary/${binary} web
Restart=always
Environment=USER=${binary} HOME=$pathtobinary

# Some distributions may not support these hardening directives. If you cannot start the service due
# to an unknown option, comment out the ones not supported by your version of systemd.
ProtectSystem=full
PrivateDevices=yes
PrivateTmp=yes
NoNewPrivileges=true

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
