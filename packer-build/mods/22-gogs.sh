#!/bin/bash

# Shellcheck fixes for: SC2181, SC2164

dependencies="wget tar git"
package="gogs"
version="0.11.91"
osarch="linux_amd64"
servername=$(hostname -f)
packageport="3005"
pathtopackage="/opt/${package}"
config_path="${pathtopackage}/custom/conf"
pathtopackagerepos="${pathtopackage}/repositories"


check_os () {
  if [ "$(grep -Ei 'VERSION_ID="16.04"' /etc/os-release)" ];
  then
    echo -e "\nSystem OS is Ubuntu. Version is 16.04.\n\n###\tProceeding with SCRIPT Execution\t###\n"
  elif [ "$(grep -Ei 'VERSION_ID="18.04"' /etc/os-release)" ];
  then
    echo -e "\nSystem OS is Ubuntu. Version is 18.04.\n\n###\tProceeding with SCRIPT Execution\t###\n"
  else
    echo -e "\nThis is neither Ubuntu 16.04 or Ubuntu 18.04.\n\n###\tScript execution HALTING!\t###\n"
    exit 2
  fi
}

setup_dependencies () {
  for dependency in ${dependencies};
  do
    if dpkg -s "${dependency}" &> /dev/null;
      then
        echo -e "\n${dependency} is already available and installed within the system."
      else
        echo -e "About to install:\t${dependency}."
        DEBIAN_FRONTEND=non-interactive apt-get install "${dependency}" -y
    fi
  done
}

add_gogs_user () {
  if id ${package} &> /dev/null;
    then
      echo -e "\nThe user:\t${package}\tdoes exist. Nothing to create\n"
    else
      echo -e "\nThe user:\t${package}\tdoesn't exist. Creating user:\t${package}\t"
      useradd --no-create-home --shell /bin/false ${package}
  fi
}

remove_gogs_user () {
  if id ${package} &> /dev/null;
    then
      echo -e "\nThe user:\t${package}\tdoes exist. Removing user:\t${package}\t\n"
      userdel -r ${package}
    else
      echo -e "\nThe user:\t${package}\tdoesn't exist. Nothing to remove."
  fi
}

create_gogs_package_path () {
  if [ -d "${pathtopackage}" ];
    then
      echo -e "\nRemoving pre-existing ${package} home directory:\t${pathtopackage}\n"
      rm -rfv ${pathtopackage}
      echo -e "\nCreating ${package} home directory:\t${pathtopackage}\n"
      mkdir -pv ${pathtopackage}
    else
      echo -e "\nCreating ${package} home directory:\t${pathtopackage}\n"
      mkdir -pv ${pathtopackage}
  fi
}

remove_gogs_package_path () {
  if [ -d "${pathtopackage}" ];
    then
      echo -e "\nRemoving  ${package} home directory:\t${pathtopackage}\n"
      rm -rfv ${pathtopackage}
    else
      echo -e "\n${package} home directory:\t${pathtopackage}\tdoes not exist.\n"
  fi
}

create_gogs_repo_path () {
  if [ -d "${pathtopackagerepos}" ];
    then
      echo -e "\nRemoving pre-existing ${package} repositories directory:\t${pathtopackagerepos}\n"
      rm -rfv ${pathtopackagerepos}
      echo -e "\nCreating ${package} repositories directory:\t${pathtopackagerepos}\n"
      mkdir -pv ${pathtopackagerepos}
    else
      echo -e "\nCreating ${package} repositories directory:\t${pathtopackagerepos}\n"
      mkdir -pv ${pathtopackagerepos}
  fi
}

remove_gogs_repo_path () {
  if [ -d "${pathtopackagerepos}" ];
    then
      echo -e "\nRemoving  ${package} repositories directory:\t${pathtopackagerepos}\n"
      rm -rfv ${pathtopackagerepos}
    else
      echo -e "\n${package} repositories directory:\t${pathtopackagerepos}\tdoes not exist.\n"
  fi
}

create_gogs_config_path () {
  if [ -d "${config_path}" ];
    then
      echo -e "\nRemoving pre-existing ${package} configuration directory:\t${config_path}\n"
      rm -rfv ${config_path}
      echo -e "\nCreating ${package} configuration directory:\t${config_path}\n"
      mkdir -pv ${config_path}
    else
      echo -e "\nCreating ${package} configuration directory:\t${config_path}\n"
      mkdir -pv ${config_path}
  fi
}

remove_gogs_config_path () {
  if [ -d "${config_path}" ];
    then
      echo -e "\nRemoving  ${package} configuration directory:\t${config_path}\n"
      rm -rfv ${config_path}
    else
      echo -e "\n${package} configuration directory:\t${config_path}\tdoes not exist.\n"
  fi
}

check_if_gogs_installed () {
  check_if_gogs_service_exists
  check_if_gogs_service_running
}

gogs_config_file_template () {
  cat <<EOF >${config_path}/app.ini
PP_NAME = Repository Manager
RUN_USER = ${package}
RUN_MODE = prod

[database]
DB_TYPE  = sqlite3
HOST     = 127.0.0.1:3306
NAME     = ${package}
USER     = ${package}
PASSWD   =
SSL_MODE = disable
PATH     = data/${package}.db

[repository]
ROOT = ${pathtopackagerepos}

[server]
DOMAIN           = ${servername}
HTTP_PORT        = ${packageport}
ROOT_URL         = http://${servername}:${packageport}/
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
ROOT_PATH = ${pathtopackage}/log

[security]
INSTALL_LOCK = true
SECRET_KEY   = JPOSWwnjJZ8wmgo

EOF
}

create_gogs_config_file () {
  if [ -f "${config_path}/app.ini" ];
    then
      echo -e "\nRemoving pre-existing ${package} config file:\t${config_path}/app.ini\n"
      rm -rfv ${config_path}/app.ini
      echo -e "\nCreating ${package} config file:\t${config_path}/app.ini\n"
      gogs_config_file_template
    else
      echo -e "\nCreating ${package} config file:\t${config_path}/app.ini\n"
      gogs_config_file_template
  fi
}

remove_gogs_config_file () {
  if [ -f "${config_path}/${package}.ini" ];
    then
      echo -e "\nRemoving  ${package} config file:\t${config_path}/${package}.ini\n"
      rm -rfv ${config_path}/${package}.ini
    else
      echo -e "\n${package} config file:\t${config_path}/${package}.ini\tdoes not exist.\n"
  fi
}

gogs_installer () {
  echo -e "\nDownloading ${package} ....."
  wget -v -O /tmp/${package}.tar.gz https://dl.${package}.io/${version}/${package}_${version}_${osarch}.tar.gz  &> /dev/null
  echo -e "\nExtracting: /tmp/${package}.tar.gz \t to:\t${pathtopackage}"
  tar -xzf /tmp/${package}.tar.gz -C ${pathtopackage} --strip-components=1
  echo -e "\nRemoving:\t/tmp/${package}.tar.gz" && rm -rv /tmp/${package}.tar.gz
  echo -e "\nAssigning ownership of:\t${pathtopackage}\n"
  chown -R ${package}:${package} ${pathtopackage}
  echo -e "\nEnsuring appropriate permission of:\t${pathtopackage}/${package}\n"
  chmod -v 0755 ${pathtopackage}/${package}
}

check_if_gogs_service_exists () {
  fragment_path=$(systemctl show -p FragmentPath ${package} | sed 's/^[^=]*=//g' || true)
  if [[ -z "${fragment_path}" ]];
  then
    echo -e "\nNO: ${package} service does not exist on the system.\n"
  else
    echo -e "\nYES: ${package} service exists on the system. It exists at:\t${fragment_path}"
  fi
}

check_if_gogs_service_running () {
  fragment_path=$(systemctl show -p FragmentPath ${package} | sed 's/^[^=]*=//g' || true)
  service_state=$(systemctl is-active ${package} || true)
  if [[ -z "${fragment_path}" ]];
  then
    echo -e "\nNO: ${package} service is not available.\n"
  elif [[ "${service_state}" = "active" ]];
  then
    echo -e "\nYES: ${package} service is in active running state."
  else
    echo -e "\nYES: ${package} service is not in active running state."
  fi
}

add_gogs_service () {
  echo -e "\nCreating service for:\t${package}"
  cat <<EOF >/etc/systemd/system/${package}.service
[Unit]
Description=${package}
Wants=network-online.target
After=network-online.target
# After=mariadb.service mysqld.service postgresql.service memcached.service redis.service

[Service]
# Modify these two values and uncomment them if you have
# repos with lots of files and get an HTTP error 500 because of that
#LimitMEMLOCK=infinity
#LimitNOFILE=65535
Type=simple
User=${package}
Group=${package}
WorkingDirectory=${pathtopackage}
ExecStart=${pathtopackage}/${package} web
Restart=always
Environment=USER=${package} HOME=${pathtopackage}

# Some distributions may not support these hardening directives. If you cannot start the service due
# to an unknown option, comment out the ones not supported by your version of systemd.
ProtectSystem=full
PrivateDevices=yes
PrivateTmp=yes
NoNewPrivileges=true

[Install]
WantedBy=multi-user.target

EOF
}

remove_gogs_service () {
  fragment_path=$(systemctl show -p FragmentPath ${package} | sed 's/^[^=]*=//g' || true)
  if [[ -z "${fragment_path}" ]];
  then
    echo -e "Service file for:\t${package} does not exist."
  else
    package_service_loc=$(systemctl show -p FragmentPath ${package} | sed 's/^[^=]*=//g')
    rm -v ${package_service_loc}
  fi
}

systemctl_daemon_reload () {
  echo -e "\nPerforming systemctl daemon reload."
  systemctl daemon-reload
}

gogs_service_status () {
  fragment_path=$(systemctl show -p FragmentPath ${package} | sed 's/^[^=]*=//g' || true)
  if [[ -z "${fragment_path}" ]];
  then
    echo -e "Service:\t${package} does not exist."
  else
    systemctl status --no-pager -l ${package}
  fi
}

gogs_service_enable () {
  fragment_path=$(systemctl show -p FragmentPath ${package} | sed 's/^[^=]*=//g' || true)
  if [[ -z "${fragment_path}" ]];
  then
    echo -e "Service:\t${package} does not exist."
  else
    systemctl enable ${package}
  fi
}

gogs_service_disable () {
  fragment_path=$(systemctl show -p FragmentPath ${package} | sed 's/^[^=]*=//g' || true)
  if [[ -z "${fragment_path}" ]];
  then
    echo -e "Service:\t${package} does not exist."
  else
    systemctl disable ${package}
  fi
}

gogs_service_start () {
  fragment_path=$(systemctl show -p FragmentPath ${package} | sed 's/^[^=]*=//g' || true)
  if [[ -z "${fragment_path}" ]];
  then
    echo -e "Service:\t${package} does not exist."
  else
    systemctl start ${package}
  fi
}

gogs_service_restart () {
  fragment_path=$(systemctl show -p FragmentPath ${package} | sed 's/^[^=]*=//g' || true)
  if [[ -z "${fragment_path}" ]];
  then
    echo -e "Service:\t${package} does not exist."
  else
    systemctl restart ${package}
  fi
}

gogs_service_stop () {
  fragment_path=$(systemctl show -p FragmentPath ${package} | sed 's/^[^=]*=//g' || true)
  if [[ -z "${fragment_path}" ]];
  then
    echo -e "Service:\t${package} does not exist."
  else
    systemctl stop ${package}
  fi
}

case "$1" in
  check)
    check_os
    check_if_gogs_installed
    ;;
  install)
    check_os
    setup_dependencies
    check_if_gogs_installed
    echo -e "\nInstallation beginning for:\t${package}\n"
    add_gogs_user
    create_gogs_package_path
    create_gogs_repo_path
    create_gogs_config_path
    create_gogs_config_file
    gogs_installer
    add_gogs_service
    systemctl_daemon_reload
    gogs_service_enable
    gogs_service_restart
    ;;
  status)
    check_os
    gogs_service_status
    ;;
  enable)
    check_os
    gogs_service_enable
    ;;
  disable)
    check_os
    gogs_service_disable
    ;;
  start)
    check_os
    gogs_service_start
    ;;
  restart)
    check_os
    gogs_service_restart
    ;;
  stop)
    check_os
    gogs_service_stop
    ;;
  uninstall)
    check_os
    gogs_service_stop
    echo -e "\nPurging beginning for:\t${package}\n"
    remove_gogs_config_file
    remove_gogs_config_path
    remove_gogs_repo_path
    remove_gogs_package_path
    remove_gogs_user
    remove_gogs_service
    systemctl_daemon_reload
    ;;
  *)
    echo -e $"\nUsage:\t $0 check\nChecks if ${package} is installed on the system and operational.\n\n"
    echo -e $"Usage:\t $0 install\nFor installing ${package} on the system and setting up it's service.\n\n"
    echo -e $"Usage:\t $0 status\nFor checking ${package} service status on the system.\n\n"
    echo -e $"Usage:\t $0 enable\nFor enabling ${package} service on boot time of the system.\n\n"
    echo -e $"Usage:\t $0 disable\nFor disabling ${package} service on boot time of the system.\n\n"
    echo -e $"Usage:\t $0 start\nFor starting ${package} service on the system.\n\n"
    echo -e $"Usage:\t $0 restart\nFor restarting ${package} service on the system.\n\n"
    echo -e $"Usage:\t $0 stop\nFor stopping ${package} service on the system.\n\n"
    echo -e $"Usage:\t $0 uninstall\nFor uninstalling/purging ${package} and it's from the system.\n\n"
    exit 1
esac
