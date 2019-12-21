#!/bin/bash -e

# Shellcheck fixes for: SC2181, SC2086, SC2164


dependencies="wget tar"
package="prometheus"
version="2.14.0"
osarch="linux-amd64"
extract_path="/usr/local/bin"
config_path="/etc/${package}"
db_path="/var/lib/${package}"


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

add_prometheus_user () {
  if id ${package} &> /dev/null;
    then
      echo -e "\nThe user:\t${package}\tdoes exist. Nothing to create\n"
    else
      echo -e "\nThe user:\t${package}\tdoesn't exist. Creating user:\t${package}\t"
      useradd --no-create-home --shell /bin/false ${package}
  fi
}

remove_prometheus_user () {
  if id ${package} &> /dev/null;
    then
      echo -e "\nThe user:\t${package}\tdoes exist. Removing user:\t${package}\t\n"
      userdel -r ${package}
    else
      echo -e "\nThe user:\t${package}\tdoesn't exist. Nothing to remove."
  fi
}

create_prometheus_config_path () {
  if [ -d "${config_path}" ];
    then
      echo -e "\nRemoving pre-existing ${package} configuration directory:\t${config_path}.\n"
      rm -rfv ${config_path}
      echo -e "\nCreating ${package} configuration directory:\t${config_path}\n"
      mkdir -pv ${config_path}
    else
      echo -e "\nCreating ${package} configuration directory:\t${config_path}\n"
      mkdir -pv ${config_path}
  fi
}

remove_prometheus_config_path () {
  if [ -d "${config_path}" ];
    then
      echo -e "\nRemoving  ${package} configuration directory:\t${config_path}\n"
      rm -rfv ${config_path}
    else
      echo -e "\n${package} configuration directory:\t${config_path}\tdoes not exist.\n"
  fi
}

create_prometheus_db_path () {
  if [ -d "${db_path}" ];
    then
      echo -e "\nRemoving pre-existing ${package} database directory:\t${db_path}\n"
      rm -rfv ${db_path}
      echo -e "\nCreating ${package} database directory:\t${db_path}\n"
      mkdir -pv ${db_path}
    else
      echo -e "\nCreating ${package} database directory:\t${db_path}\n"
      mkdir -pv ${db_path}
  fi
}

remove_prometheus_db_path () {
  if [ -d "${db_path}" ];
    then
      echo -e "\nRemoving  ${package} database directory:\t${db_path}\n"
      rm -rfv ${db_path}
    else
      echo -e "\n${package} database directory:\t${db_path}\tdoes not exist\n"
  fi
}

check_if_prometheus_installed () {
  check_if_prometheus_service_exists
  check_if_prometheus_service_running
  if command -v ${package} &> /dev/null;
    then
      echo -e "\nYES: ${package} is IN an installed state within the system and executable binary is present at:\t$(command -v ${package})\n"
      exit 0
    else
      echo -e "\nNO: ${package} is NOT IN an installed state.\n"
  fi
}

create_prometheus_config_file () {
  if [ -f "${config_path}/${package}.yml" ];
    then
      echo -e "\nRemoving pre-existing ${package} config file:\t${config_path}/${package}.yml\n"
      rm -rfv ${config_path}
      echo -e "\nCreating ${package} config file:\t${config_path}/${package}.yml\n"
      cat <<EOF >${config_path}/${package}.yml
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
  # - job_name: 'node'
  #   static_configs:
  #   - targets: ['localhost:9100']
  - job_name: 'prometheus'
    static_configs:
    - targets: ['localhost:9090']
  # - job_name: 'alertmanager'
  #   static_configs:
  #   - targets: ['localhost:9093']

EOF
    else
      echo -e "\nCreating ${package} config file:\t${config_path}/${package}.yml\n"
      cat <<EOF >${config_path}/${package}.yml
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
  # - job_name: 'node'
  #   static_configs:
  #   - targets: ['localhost:9100']
  - job_name: 'prometheus'
    static_configs:
    - targets: ['localhost:9090']
  # - job_name: 'alertmanager'
  #   static_configs:
  #   - targets: ['localhost:9093']

EOF
  fi
}

remove_prometheus_config_file () {
  if [ -f "${config_path}/${package}.yml" ];
    then
      echo -e "\nRemoving  ${package} config file:\t${config_path}/${package}.yml\n"
      rm -rfv ${config_path}/${package}.yml
    else
      echo -e "\n${package} config file:\t${config_path}/${package}.yml\tdoes not exist.\n"
  fi
}

prometheus_installer () {
  echo -e "\nCreating temporary directory as workspace till installation is complete."
  mkdir -pv /tmp/${package}_tempdir
  wget -v -O /tmp/${package}.tar.gz https://github.com/prometheus/${package}/releases/download/v${version}/${package}-${version}.${osarch}.tar.gz  &> /dev/null
  echo -e "\nExtracting: /tmp/${package}.tar.gz \t to:\t /tmp/${package}_tempdir"
  tar -xzf /tmp/${package}.tar.gz -C /tmp/${package}_tempdir --strip-components=1
  echo -e "\nRemoving:\t/tmp/${package}.tar.gz" && rm -rv /tmp/${package}.tar.gz
  echo -e "\nMoving binary files to:\t${extract_path}\n"
  mv -v /tmp/${package}_tempdir/${package} /tmp/${package}_tempdir/promtool ${extract_path}/
  echo -e "\nMoving console dir(s) to ${config_path}\n"
  mv -v /tmp/${package}_tempdir/${binary}/console*  ${config_path}/
  echo -e "\nAssigning ownership of:\t${extract_path}/${package}\n"
  chown -Rv ${package}:${package} ${extract_path}/${package} ${extract_path}/promtool
  echo -e "\nAssigning ownership of:\t${config_path}\n"
  chown -Rv ${package}:${package} ${config_path}
  echo -e "\nAssigning ownership of:\t${db_path}\n"
  chown -Rv ${package}:${package} ${db_path}
  echo -e "\nEnsuring appropriate permission of:\t${extract_path}/${package}\n"
  chmod -v 0755 ${extract_path}/${package} ${extract_path}/promtool
  echo -e "\nRemoving temporary directory."
  rm -rfv /tmp/${package}_tempdir
}

prometheus_uninstaller () {
  if command -v ${package} &> /dev/null;
    then
      package_loc=$(command -v ${package})
      rm -v ${package_loc}
    else
      echo -e "\nNO: ${package} is NOT IN an installed state.\n"
      exit 2
  fi
}

check_if_prometheus_service_exists () {
  fragment_path=$(systemctl show -p FragmentPath ${package} | sed 's/^[^=]*=//g' || true)
  if [[ -z "${fragment_path}" ]];
  then
    echo -e "\nNO: ${package} service does not exist on the system.\n"
  else
    echo -e "\nYES: ${package} service exists on the system. It exists at:\t${fragment_path}"
  fi
}

check_if_prometheus_service_running () {
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

add_prometheus_service () {
  echo -e "\nCreating service for:\t${package}"
  cat <<EOF >/etc/systemd/system/${package}.service
[Unit]
Description=${package} - monitoring system and time series database.
Wants=network-online.target
After=network-online.target

[Service]
User=${package}
Group=${package}
Type=simple
ExecStart=${extract_path}/${package} \
    --config.file ${config_path}/${package}.yml \
    --storage.tsdb.path ${db_path}/ \
    --web.console.templates=${config_path}/consoles \
    --web.console.libraries=${config_path}/console_libraries

[Install]
WantedBy=multi-user.target

EOF
}

remove_prometheus_service () {
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

prometheus_service_status () {
  fragment_path=$(systemctl show -p FragmentPath ${package} | sed 's/^[^=]*=//g' || true)
  if [[ -z "${fragment_path}" ]];
  then
    echo -e "Service:\t${package} does not exist."
  else
    systemctl status --no-pager -l ${package}
  fi
}

prometheus_service_enable () {
  fragment_path=$(systemctl show -p FragmentPath ${package} | sed 's/^[^=]*=//g' || true)
  if [[ -z "${fragment_path}" ]];
  then
    echo -e "Service:\t${package} does not exist."
  else
    systemctl enable ${package}
  fi
}

prometheus_service_disable () {
  fragment_path=$(systemctl show -p FragmentPath ${package} | sed 's/^[^=]*=//g' || true)
  if [[ -z "${fragment_path}" ]];
  then
    echo -e "Service:\t${package} does not exist."
  else
    systemctl disable ${package}
  fi
}

prometheus_service_start () {
  fragment_path=$(systemctl show -p FragmentPath ${package} | sed 's/^[^=]*=//g' || true)
  if [[ -z "${fragment_path}" ]];
  then
    echo -e "Service:\t${package} does not exist."
  else
    systemctl start ${package}
  fi
}

prometheus_service_restart () {
  fragment_path=$(systemctl show -p FragmentPath ${package} | sed 's/^[^=]*=//g' || true)
  if [[ -z "${fragment_path}" ]];
  then
    echo -e "Service:\t${package} does not exist."
  else
    systemctl restart ${package}
  fi
}

prometheus_service_stop () {
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
    check_if_prometheus_installed
    ;;
  install)
    check_os
    setup_dependencies
    check_if_prometheus_installed
    echo -e "\nInstallation beginning for:\t${package}\n"
    add_prometheus_user
    create_prometheus_config_path
    create_prometheus_db_path
    create_prometheus_config_file
    prometheus_installer
    add_prometheus_service
    systemctl_daemon_reload
    prometheus_service_enable
    prometheus_service_restart
    ;;
  status)
    check_os
    prometheus_service_status
    ;;
  enable)
    check_os
    prometheus_service_enable
    ;;
  disable)
    check_os
    prometheus_service_disable
    ;;
  start)
    check_os
    prometheus_service_start
    ;;
  restart)
    check_os
    prometheus_service_restart
    ;;
  stop)
    check_os
    prometheus_service_stop
    ;;
  uninstall)
    check_os
    prometheus_service_stop
    echo -e "\nPurging beginning for:\t${package}\n"
    remove_prometheus_config_file
    remove_prometheus_config_path
    remove_prometheus_db_path
    remove_prometheus_user
    prometheus_uninstaller
    remove_prometheus_service
    systemctl_daemon_reload
    ;;
  *)
    echo -e $"\nUsage:\t $0 check\t\t : Checks if ${package} is installed on the system and operational."
    echo -e $"Usage:\t $0 install\t : For installing ${package} on the system and setting up it's service."
    echo -e $"Usage:\t $0 status\t\t : For checking ${package} service status on the system."
    echo -e $"Usage:\t $0 enable\t\t : For enabling ${package} service on boot time of the system."
    echo -e $"Usage:\t $0 disable\t : For disabling ${package} service on boot time of the system."
    echo -e $"Usage:\t $0 start\t\t : For starting ${package} service on the system."
    echo -e $"Usage:\t $0 restart\t : For restarting ${package} service on the system."
    echo -e $"Usage:\t $0 stop\t\t : For stopping ${package} service on the system."
    echo -e $"Usage:\t $0 uninstall\t : For uninstalling/purging ${package} and it's from the system.\n"
    exit 1
esac
