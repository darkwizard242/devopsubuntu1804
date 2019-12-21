#!/bin/bash -e

# Shellcheck fixes for: SC2181, SC2034, SC2086, SC2006, SC2164

dependencies="wget tar"
package="node_exporter"
version="0.18.1"
osarch="linux-amd64"
extract_path="/usr/local/bin"


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

add_node_exporter_user () {
  if id ${package} &> /dev/null;
    then
      echo -e "\nThe user:\t${package}\tdoes exist. Nothing to create\n"
    else
      echo -e "\nThe user:\t${package}\tdoesn't exist. Creating user:\t${package}\t"
      useradd --no-create-home --shell /bin/false ${package}
  fi
}

remove_node_exporter_user () {
  if id ${package} &> /dev/null;
    then
      echo -e "\nThe user:\t${package}\tdoes exist. Removing user:\t${package}\t\n"
      userdel -r ${package}
    else
      echo -e "\nThe user:\t${package}\tdoesn't exist. Nothing to remove."
  fi
}

check_if_node_exporter_installed () {
  check_if_node_exporter_service_exists
  check_if_node_exporter_service_running
  if command -v ${package} &> /dev/null;
    then
      echo -e "\nYES: ${package} is IN an installed state within the system and executable binary is present at:\t$(command -v ${package})\n"
      exit 0
    else
      echo -e "\nNO: ${package} is NOT IN an installed state.\n"
  fi
}

node_exporter_installer () {
  echo -e "\nCreating temporary directory as workspace till installation is complete."
  mkdir -pv /tmp/${package}_tempdir
  wget -v -O /tmp/${package}.tar.gz https://github.com/prometheus/${package}/releases/download/v${version}/${package}-${version}.${osarch}.tar.gz  &> /dev/null
  echo -e "\nExtracting: /tmp/${package}.tar.gz \t to:\t /tmp/${package}_tempdir"
  tar -xzf /tmp/${package}.tar.gz -C /tmp/${package}_tempdir --strip-components=1
  echo -e "\nRemoving:\t/tmp/${package}.tar.gz" && rm -rv /tmp/${package}.tar.gz
  echo -e "\nMoving binary files to:\t${extract_path}\n"
  mv -v /tmp/${package}_tempdir/${package} ${extract_path}/
  echo -e "\nAssigning ownership of:\t${extract_path}/${package}\n"
  chown -Rv ${package}:${package} ${extract_path}/${package}
  echo -e "\nEnsuring appropriate permission of:\t${extract_path}/${package}\n"
  chmod -v 0755 ${extract_path}/${package}
  echo -e "\nRemoving temporary directory."
  rm -rfv /tmp/${package}_tempdir
}

node_exporter_uninstaller () {
  if command -v ${package} &> /dev/null;
    then
      package_loc=$(command -v ${package})
      rm -v ${package_loc}
    else
      echo -e "\nNO: ${package} is NOT IN an installed state.\n"
      exit 2
  fi
}

check_if_node_exporter_service_exists () {
  fragment_path=$(systemctl show -p FragmentPath ${package} | sed 's/^[^=]*=//g' || true)
  if [[ -z "${fragment_path}" ]];
  then
    echo -e "\nNO: ${package} service does not exist on the system.\n"
  else
    echo -e "\nYES: ${package} service exists on the system. It exists at:\t${fragment_path}"
  fi
}

check_if_node_exporter_service_running () {
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

add_node_exporter_service () {
  echo -e "\nCreating service for:\t${package}"
  cat <<EOF >/etc/systemd/system/${package}.service
[Unit]
Description=node_exporter - exporter for machine metrics.
After=network.target

[Service]
User=${package}
Group=${package}
Type=simple
ExecStart=${extract_path}/${package} --collector.systemd --collector.processes --collector.mountstats

[Install]
WantedBy=multi-user.target
EOF
}

remove_node_exporter_service () {
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

node_exporter_service_status () {
  fragment_path=$(systemctl show -p FragmentPath ${package} | sed 's/^[^=]*=//g' || true)
  if [[ -z "${fragment_path}" ]];
  then
    echo -e "Service:\t${package} does not exist."
  else
    systemctl status --no-pager -l ${package}
  fi
}

node_exporter_service_enable () {
  fragment_path=$(systemctl show -p FragmentPath ${package} | sed 's/^[^=]*=//g' || true)
  if [[ -z "${fragment_path}" ]];
  then
    echo -e "Service:\t${package} does not exist."
  else
    systemctl enable ${package}
  fi
}

node_exporter_service_disable () {
  fragment_path=$(systemctl show -p FragmentPath ${package} | sed 's/^[^=]*=//g' || true)
  if [[ -z "${fragment_path}" ]];
  then
    echo -e "Service:\t${package} does not exist."
  else
    systemctl disable ${package}
  fi
}

node_exporter_service_start () {
  fragment_path=$(systemctl show -p FragmentPath ${package} | sed 's/^[^=]*=//g' || true)
  if [[ -z "${fragment_path}" ]];
  then
    echo -e "Service:\t${package} does not exist."
  else
    systemctl start ${package}
  fi
}

node_exporter_service_restart () {
  fragment_path=$(systemctl show -p FragmentPath ${package} | sed 's/^[^=]*=//g' || true)
  if [[ -z "${fragment_path}" ]];
  then
    echo -e "Service:\t${package} does not exist."
  else
    systemctl restart ${package}
  fi
}

node_exporter_service_stop () {
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
    check_if_node_exporter_installed
    ;;
  install)
    check_os
    setup_dependencies
    check_if_node_exporter_installed
    echo -e "\nInstallation beginning for:\t${package}\n"
    add_node_exporter_user
    node_exporter_installer
    add_node_exporter_service
    systemctl_daemon_reload
    node_exporter_service_enable
    node_exporter_service_restart
    ;;
  status)
    check_os
    node_exporter_service_status
    ;;
  enable)
    check_os
    node_exporter_service_enable
    ;;
  disable)
    check_os
    node_exporter_service_disable
    ;;
  start)
    check_os
    node_exporter_service_start
    ;;
  restart)
    check_os
    node_exporter_service_restart
    ;;
  stop)
    check_os
    node_exporter_service_stop
    ;;
  uninstall)
    check_os
    node_exporter_service_stop
    echo -e "\nPurging beginning for:\t${package}\n"
    remove_node_exporter_user
    node_exporter_uninstaller
    node_exporter_service_stop
    remove_node_exporter_service
    systemctl_daemon_reload
    ;;
  *)
    echo -e $"\nUsage:\t $0 check\t : Checks if ${package} is installed on the system and operational."
    echo -e $"Usage:\t $0 install\t : For installing ${package} on the system and setting up it's service."
    echo -e $"Usage:\t $0 status\t : For checking ${package} service status on the system."
    echo -e $"Usage:\t $0 enable\t : For enabling ${package} service on boot time of the system."
    echo -e $"Usage:\t $0 disable\t : For disabling ${package} service on boot time of the system."
    echo -e $"Usage:\t $0 start\t : For starting ${package} service on the system."
    echo -e $"Usage:\t $0 restart\t : For restarting ${package} service on the system."
    echo -e $"Usage:\t $0 stop\t\t : For stopping ${package} service on the system."
    echo -e $"Usage:\t $0 uninstall\t : For uninstalling/purging ${package} and it's from the system.\n"
    exit 1
esac
