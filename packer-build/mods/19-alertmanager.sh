#!/bin/bash -e

# Shellcheck fixes for: SC2181, SC2086, SC2164, SC2028, SC2034, SC2161

dependencies="wget tar"
package="alertmanager"
version="0.20.0"
osarch="linux-amd64"
extract_path="/usr/local/bin"
config_path="/etc/${package}"
log_config_path="/etc/rsyslog.d"
log_out="/var/log/${package}.log"


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

add_alertmanager_user () {
  if id ${package} &> /dev/null;
    then
      echo -e "\nThe user:\t${package}\tdoes exist. Nothing to create\n"
    else
      echo -e "\nThe user:\t${package}\tdoesn't exist. Creating user:\t${package}\t"
      useradd --no-create-home --shell /bin/false ${package}
  fi
}

remove_alertmanager_user () {
  if id ${package} &> /dev/null;
    then
      echo -e "\nThe user:\t${package}\tdoes exist. Removing user:\t${package}\t\n"
      userdel -r ${package}
    else
      echo -e "\nThe user:\t${package}\tdoesn't exist. Nothing to remove."
  fi
}

alertmanager_log_config_template () {
  cat <<EOF >${log_config_path}/${package}.conf
if ( \$programname startswith "${package}" ) then {
    action(type="omfile" file="${log_out}" flushOnTXEnd="off" asyncWriting="on")
    stop
}

EOF
}

create_alertmanager_log_config () {
  if [ -f "${log_config_path}/${package}.conf" ];
    then
      echo -e "\nRemoving pre-existing ${package} rsyslog config file:\t${log_config_path}/${package}.conf\n"
      rm -rfv ${log_config_path}/${package}.conf
      echo -e "\nCreating ${package} rsyslog config file:\t${log_config_path}/${package}.conf\n"
      alertmanager_log_config_template
    else
      echo -e "\nCreating ${package} rsyslog config file:\t${log_config_path}/${package}.conf\n"
      alertmanager_log_config_template
  fi
}

remove_alertmanager_log_config () {
  if [ -f "${log_config_path}/${package}.conf" ];
    then
      echo -e "\nRemoving ${package} rsyslog config file:\t${log_config_path}/${package}.conf\n"
      rm -rfv ${log_config_path}/${package}.conf
    else
      echo -e "\n${package} rsyslog config file:\t${log_config_path}/${package}.conf\tdoes not exist.\n"
  fi
}

create_alertmanager_config_path () {
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

remove_alertmanager_config_path () {
  if [ -d "${config_path}" ];
    then
      echo -e "\nRemoving  ${package} configuration directory:\t${config_path}\n"
      rm -rfv ${config_path}
    else
      echo -e "\n${package} configuration directory:\t${config_path}\tdoes not exist.\n"
  fi
}


check_if_alertmanager_installed () {
  check_if_alertmanager_service_exists
  check_if_alertmanager_service_running
  if command -v ${package} &> /dev/null;
    then
      echo -e "\nYES: ${package} is IN an installed state within the system and executable binary is present at:\t$(command -v ${package})\n"
      exit 0
    else
      echo -e "\nNO: ${package} is NOT IN an installed state.\n"
  fi
}

alertmanager_config_file_template () {
  cat <<EOF >${config_path}/${package}.yml
global:
  resolve_timeout: 5m

route:
  group_by: ['alertname']
  group_wait: 10s
  group_interval: 10s
  repeat_interval: 1m
  receiver: 'web.hook'
  # receiver: 'slack'
  routes:
    - match:
        severity: page
      group_by: ['team']
      receiver: 'web.hook'
      routes:
        - match:
            team: devops
          receiver: 'web.hook'
#
#
receivers:
- name: 'web.hook'
  webhook_configs:
  - url: 'http://127.0.0.1:5001/'
# - name: 'slack'
#   slack_configs:
#   - channel: "prometheus"
#     api_url:
#     text: "Overview: {{ .CommonAnnotations.summary }}"
inhibit_rules:
 - source_match:
     severity: 'page'
   target_match:
     severity: 'ticket'
   equal: ['team']

EOF
}

create_alertmanager_config_file () {
  if [ -f "${config_path}/${package}.yml" ];
    then
      echo -e "\nRemoving pre-existing ${package} config file:\t${config_path}/${package}.yml\n"
      rm -rfv ${config_path}/${package}.yml
      echo -e "\nCreating ${package} config file:\t${config_path}/${package}.yml\n"
      alertmanager_config_file_template
    else
      echo -e "\nCreating ${package} config file:\t${config_path}/${package}.yml\n"
      alertmanager_config_file_template
  fi
}

remove_alertmanager_config_file () {
  if [ -f "${config_path}/${package}.yml" ];
    then
      echo -e "\nRemoving  ${package} config file:\t${config_path}/${package}.yml\n"
      rm -rfv ${config_path}/${package}.yml
    else
      echo -e "\n${package} config file:\t${config_path}/${package}.yml\tdoes not exist.\n"
  fi
}

alertmanager_installer () {
  echo -e "\nCreating temporary directory as workspace till installation is complete."
  mkdir -pv /tmp/${package}_tempdir
  wget -v -O /tmp/${package}.tar.gz https://github.com/prometheus/${package}/releases/download/v${version}/${package}-${version}.${osarch}.tar.gz  &> /dev/null
  echo -e "\nExtracting: /tmp/${package}.tar.gz \t to:\t /tmp/${package}_tempdir"
  tar -xzf /tmp/${package}.tar.gz -C /tmp/${package}_tempdir --strip-components=1
  echo -e "\nRemoving:\t/tmp/${package}.tar.gz" && rm -rv /tmp/${package}.tar.gz
  echo -e "\nMoving binary files to:\t${extract_path}\n"
  mv -v /tmp/${package}_tempdir/${package} /tmp/${package}_tempdir/amtool ${extract_path}/
  echo -e "\nAssigning ownership of:\t${extract_path}/${package}\n"
  chown -Rv ${package}:${package} ${extract_path}/${package} ${extract_path}/amtool
  echo -e "\nAssigning ownership of:\t${config_path}\n"
  chown -Rv ${package}:${package} ${config_path}
  echo -e "\nEnsuring appropriate permission of:\t${extract_path}/${package}\n"
  chmod -v 0755 ${extract_path}/${package} ${extract_path}/amtool
  echo -e "\nRemoving temporary directory."
  rm -rfv /tmp/${package}_tempdir
}

alertmanager_uninstaller () {
  if command -v ${package} &> /dev/null;
    then
      package_loc=$(command -v ${package})
      rm -v ${package_loc}
    else
      echo -e "\nNO: ${package} is NOT IN an installed state.\n"
      exit 2
  fi
}

check_if_alertmanager_service_exists () {
  fragment_path=$(systemctl show -p FragmentPath ${package} | sed 's/^[^=]*=//g' || true)
  if [[ -z "${fragment_path}" ]];
  then
    echo -e "\nNO: ${package} service does not exist on the system.\n"
  else
    echo -e "\nYES: ${package} service exists on the system. It exists at:\t${fragment_path}"
  fi
}

check_if_alertmanager_service_running () {
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

add_alertmanager_service () {
  echo -e "\nCreating service for:\t${package}"
  cat <<EOF >/etc/systemd/system/${package}.service
[Unit]
Description=${package} - manages alerting based on rules.
Wants=network-online.target
After=network-online.target

[Service]
User=${package}
Group=${package}
Type=simple
WorkingDirectory=${config_path}
ExecStart=${extract_path}/${package} \
    --config.file ${config_path}/${package}.yml
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=${package}

[Install]
WantedBy=multi-user.target

EOF
}

remove_alertmanager_service () {
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

alertmanager_service_status () {
  fragment_path=$(systemctl show -p FragmentPath ${package} | sed 's/^[^=]*=//g' || true)
  if [[ -z "${fragment_path}" ]];
  then
    echo -e "Service:\t${package} does not exist."
  else
    systemctl status --no-pager -l ${package}
  fi
}

alertmanager_service_enable () {
  fragment_path=$(systemctl show -p FragmentPath ${package} | sed 's/^[^=]*=//g' || true)
  if [[ -z "${fragment_path}" ]];
  then
    echo -e "Service:\t${package} does not exist."
  else
    systemctl enable ${package}
  fi
}

alertmanager_service_disable () {
  fragment_path=$(systemctl show -p FragmentPath ${package} | sed 's/^[^=]*=//g' || true)
  if [[ -z "${fragment_path}" ]];
  then
    echo -e "Service:\t${package} does not exist."
  else
    systemctl disable ${package}
  fi
}

alertmanager_service_start () {
  fragment_path=$(systemctl show -p FragmentPath ${package} | sed 's/^[^=]*=//g' || true)
  if [[ -z "${fragment_path}" ]];
  then
    echo -e "Service:\t${package} does not exist."
  else
    systemctl start ${package}
  fi
}

alertmanager_service_restart () {
  fragment_path=$(systemctl show -p FragmentPath ${package} | sed 's/^[^=]*=//g' || true)
  if [[ -z "${fragment_path}" ]];
  then
    echo -e "Service:\t${package} does not exist."
  else
    systemctl restart ${package}
  fi
}

alertmanager_service_stop () {
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
    check_if_alertmanager_installed
    ;;
  install)
    check_os
    setup_dependencies
    check_if_alertmanager_installed
    echo -e "\nInstallation beginning for:\t${package}\n"
    add_alertmanager_user
    create_alertmanager_log_config && systemctl restart rsyslog.service
    create_alertmanager_config_path
    create_alertmanager_config_file
    alertmanager_installer
    add_alertmanager_service
    systemctl_daemon_reload
    alertmanager_service_enable
    alertmanager_service_restart
    ;;
  status)
    check_os
    alertmanager_service_status
    ;;
  enable)
    check_os
    alertmanager_service_enable
    ;;
  disable)
    check_os
    alertmanager_service_disable
    ;;
  start)
    check_os
    alertmanager_service_start
    ;;
  restart)
    check_os
    alertmanager_service_restart
    ;;
  stop)
    check_os
    alertmanager_service_stop
    ;;
  uninstall)
    check_os
    alertmanager_service_stop
    remove_alertmanager_log_config && systemctl restart rsyslog.service
    echo -e "\nPurging beginning for:\t${package}\n"
    remove_alertmanager_config_file
    remove_alertmanager_config_path
    remove_alertmanager_user
    alertmanager_uninstaller
    remove_alertmanager_service
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
