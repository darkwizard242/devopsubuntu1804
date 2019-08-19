#!/bin/bash


dependencies="wget tar git"
servername=$(hostname -f)
binary="gogs"
version="0.11.91"
osarch="linux_amd64"
pathtobinary="/opt/${binary}"
pathtobinaryrepos="${pathtobinary}/repositories"

## Installing packages required for $binary
for dependency in $dependencies;
do
  dpkg -s "$dependency" &> /dev/null && echo -e
  if [ $? -eq 0 ];
    then
      echo "$dependency is already available and installed within the system." && echo -e
    else
      echo "About to install $dependency." && echo -e
      DEBIAN_FRONTEND=non-interactive apt-get install "$dependency" -y
  fi
done



## Download Gogs and setup/configure.

if [ -e /opt/${binary}/${binary} ]
then
  echo "${binary} binary currently exists in /opt/${binary}/ !"
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
  wget -v https://dl.${binary}.io/${version}/${binary}_${version}_${osarch}.tar.gz
  if [ -d "$pathtobinary" ];
  then
    echo -e "\nDirectory: $pathtobinary exists. About to remove it.\n"
    rm -rfv "$pathtobinary"
  else
    echo -e "\nDirectory: $pathtobinary doesn't exist. Creating $pathtobinary !\n"
    mkdir -pv "$pathtobinary"
  fi
  if [ -d "$pathtobinaryrepos" ];
  then
    echo -e "\nDirectory: $pathtobinaryrepos exists. About to remove it.\n"
    rm -rfv "$pathtobinaryrepos"
  else
    echo -e "\nDirectory: $pathtobinary doesn't exist. Creating $pathtobinaryrepos !\n"
    mkdir -pv "$pathtobinaryrepos"
  fi
  tar -xzf ${binary}_${version}_${osarch}.tar.gz -C "$pathtobinary" --strip-components=1 && rm -r ${binary}_${version}_${osarch}.tar.gz
  cd "$pathtobinary"
  mkdir -pv "$pathtobinary"/custom/conf/
  cat <<EOF >"$pathtobinary"/custom/conf/app.ini
PP_NAME = SA Repository Manager
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
HTTP_PORT        = 3000
ROOT_URL         = http://${servername}:3000/
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
  chown -Rv ${binary}:${binary} "$pathtobinary"
  echo -e "\nCreating service for ${binary}"
  cat <<EOF >/etc/systemd/system/${binary}.service
[Unit]
Description=Gogs
After=syslog.target
After=network.target
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
EOF
  echo -e "\nPerforming systemctl daemon reload."
  systemctl daemon-reload
  # echo -e "\nEnabling systemctl service for ${binary}."
  # systemctl enable ${binary}.service
  echo -e "\nStarting systemctl service for ${binary}.\n"
  systemctl start ${binary}.service
  echo -e "\n"
fi