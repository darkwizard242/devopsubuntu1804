#!/bin/bash -e

# Shellcheck fixes for: SC2034

dependencies="curl wget jq"
package="osquery"
packageinteractive="osqueryi"
packageservice="osqueryd"
version="4.1.2"
osarch="linux.amd64"
pathtointeractivepackage="/usr/bin/${packageinteractive}"


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

check_if_osquery_service_exists () {
  fragment_path=$(systemctl show -p FragmentPath ${packageservice} | sed 's/^[^=]*=//g' || true)
  if [[ -z "${fragment_path}" ]];
  then
    echo -e "\nNO: ${packageservice} service does not exist on the system.\n"
  else
    echo -e "\nYES: ${packageservice} service exists on the system. It exists at:\t${fragment_path}"
  fi
}

check_if_osquery_service_running () {
  fragment_path=$(systemctl show -p FragmentPath ${packageservice} | sed 's/^[^=]*=//g' || true)
  service_state=$(systemctl is-active ${packageservice} || true)
  if [[ -z "${fragment_path}" ]];
  then
    echo -e "\nNO: ${packageservice} service is not available.\n"
  elif [[ "${service_state}" = "active" ]];
  then
    echo -e "\nYES: ${packageservice} service is in active running state."
  else
    echo -e "\nYES: ${packageservice} service is not in active running state."
  fi
}

check_if_osquery_installed () {
  check_if_osquery_service_exists
  check_if_osquery_service_running
  if command -v ${packageinteractive} &> /dev/null;
    then
      echo -e "\nYES: ${package} is IN an installed state within the system.\n"
      exit 0
    else
      echo -e "\nNO: ${package} is NOT IN an installed state.\n"
  fi
}

osquery_downloader () {
  wget -v -O /tmp/${package}.deb https://pkg.${package}.io/deb/${package}_${version}_1.${osarch}.deb &> /dev/null
}

osquery_installer () {
  dpkg -i /tmp/${package}.deb
  echo -e "\nRemoving the .deb file for ${package}."
  rm -v /tmp/${package}.deb
  echo -e "\nCreating configuration file for ${package} in /etc/${package} as /etc/${package}/${package}.conf"
  cp -v /usr/share/${package}/${package}.example.conf /etc/${package}/${package}.conf
}

osquery_uninstaller () {
  if dpkg -l | grep ${package} &> /dev/null;
  then
    DEBIAN_FRONTEND=non-interactive dpkg --purge ${package}
  else
    echo -e "\nNO: ${package} does not exist in the dpkg list."
  fi
  osquery_dirs="/var/${package} /etc/${package} /var/log/${package}"
  for dirs in ${osquery_dirs};
  do
    if [ -d "${dirs}" ];
    then
      echo -e "\nRemoving  ${package} directory:\t${dirs}\n"
      rm -rf ${dirs}
    else
      echo -e "\n${package} directory:\t${dirs}\tdoes not exist.\n"
    fi
  done
}

remove_osquery_service () {
  fragment_path=$(systemctl show -p FragmentPath ${packageservice} | sed 's/^[^=]*=//g' || true)
  if [[ -z "${fragment_path}" ]];
  then
    echo -e "Service file for:\t${packageservice} does not exist."
  else
    package_service_loc=$(systemctl show -p FragmentPath ${packageservice} | sed 's/^[^=]*=//g')
    rm -v ${package_service_loc}
  fi
}


osquery_usage_examples () {
  cat << EOF
## SAMPLE SQL queries for osqueryi - DEBIAN/UBUNTU system based

# 1. Fetch data in json format and parse to jq. SELECT STATEMENT to retrieve data for following columns against processes table in Descending order based upon the total_size column:
# Columns Fetched are:
# - pid
# - name
# - state
# - total_size (total_size contains data in bytes which is converted to MB's by dividing the value with 1024*1024)
SQL QUERY: osqueryi --json "SELECT pid,name,state,total_size/(1024*1024) FROM processes ORDER by total_size DESC" | jq  -r '.[0]'


# 2. Fetch data in json format and parse to jq. SELECT STATEMENT to retrieve data for all columns against os_version:
SQL QUERY: osqueryi --json "SELECT * FROM os_version" | jq


# 3. Fetch data in json format and parse to jq. SELECT STATEMENT to retrieve data for following columns against listening_ports table where port is equal to 8080:
# Columns Fetched are:
# - pid
# - port
# - protocol
SQL QUERY: osqueryi --json "SELECT pid,port,protocol FROM listening_ports WHERE port=8080" | jq

# 4. Fetch data in json format and parse to jq. SELECT STATEMENT to retrieve data for all columns against etc_hosts:
# SQL QUERY: osqueryi --json "SELECT * FROM etc_hosts" | jq
# Extract only values for address key in raw output using jq:
SQL QUERY: osqueryi --json "SELECT * FROM etc_hosts" | jq -r '.[] | .address'


# 5. Fetch data in json format and parse to jq. SELECT STATEMENT to retrieve data all columns against deb_packages table name of package is equal to osquery:
SQL QUERY: osqueryi --json "SELECT * from deb_packages WHERE name='osquery'" | jq


# 6. Fetch data in json format and parse to jq. SELECT STATEMENT to retrieve data for all columns against crontab:
SQL QUERY: osqueryi --json "SELECT * FROM crontab" | jq


# 7. Fetch data in json format and parse to jq. SELECT STATEMENT to retrieve data for all columns against file where path is /etc/hosts:
SQL QUERY: osqueryi --json "SELECT * from file where path='/etc/hosts'" | jq


# 8. Fetch data in json format and parse to jq. SELECT STATEMENT to retrieve data for all columns against logged_in_users:
SQL QUERY: osqueryi --json "SELECT * from logged_in_users" | jq

EOF
}


systemctl_daemon_reload () {
  echo -e "\nPerforming systemctl daemon reload."
  systemctl daemon-reload
}

osquery_service_status () {
  fragment_path=$(systemctl show -p FragmentPath ${packageservice} | sed 's/^[^=]*=//g' || true)
  if [[ -z "${fragment_path}" ]];
  then
    echo -e "Service:\t${packageservice} does not exist."
  else
    systemctl status --no-pager -l ${packageservice}
  fi
}

osquery_service_enable () {
  fragment_path=$(systemctl show -p FragmentPath ${packageservice} | sed 's/^[^=]*=//g' || true)
  if [[ -z "${fragment_path}" ]];
  then
    echo -e "Service:\t${packageservice} does not exist."
  else
    systemctl enable ${packageservice}
  fi
}

osquery_service_disable () {
  fragment_path=$(systemctl show -p FragmentPath ${packageservice} | sed 's/^[^=]*=//g' || true)
  if [[ -z "${fragment_path}" ]];
  then
    echo -e "Service:\t${packageservice} does not exist."
  else
    systemctl disable ${packageservice}
  fi
}

osquery_service_start () {
  fragment_path=$(systemctl show -p FragmentPath ${packageservice} | sed 's/^[^=]*=//g' || true)
  if [[ -z "${fragment_path}" ]];
  then
    echo -e "Service:\t${packageservice} does not exist."
  else
    systemctl start ${packageservice}
  fi
}

osquery_service_restart () {
  fragment_path=$(systemctl show -p FragmentPath ${packageservice} | sed 's/^[^=]*=//g' || true)
  if [[ -z "${fragment_path}" ]];
  then
    echo -e "Service:\t${package} does not exist."
  else
    systemctl restart ${packageservice}
  fi
}

osquery_service_stop () {
  fragment_path=$(systemctl show -p FragmentPath ${packageservice} | sed 's/^[^=]*=//g' || true)
  if [[ -z "${fragment_path}" ]];
  then
    echo -e "Service:\t${packageservice} does not exist."
  else
    systemctl stop ${packageservice}
  fi
}

case "$1" in
  check)
    check_os
    check_if_osquery_installed
    ;;
  install)
    check_os
    check_if_osquery_installed
    echo -e "\nInstallation beginning for:\t${package}\n"
    osquery_downloader
    osquery_installer
    systemctl_daemon_reload
    osquery_service_enable
    ;;
  status)
    check_os
    osquery_service_status
    ;;
  enable)
    check_os
    osquery_service_enable
    ;;
  disable)
    check_os
    osquery_service_disable
    ;;
  start)
    check_os
    osquery_service_start
    ;;
  restart)
    check_os
    osquery_service_restart
    ;;
  stop)
    check_os
    osquery_service_stop
    ;;
  examples)
    osquery_usage_examples
    ;;
  uninstall)
    check_os
    osquery_service_stop
    osquery_service_disable
    systemctl_daemon_reload
    echo -e "\nPurging beginning for:\t${package}\n"
    osquery_uninstaller
    remove_osquery_service
    ;;
  *)
    echo -e $"\nUsage:\t $0 check\nChecks if ${package} is installed on the system.\n\n"
    echo -e $"Usage:\t $0 install\nFor installing ${package} from the system.\n\n"
    echo -e $"Usage:\t $0 status\nFor checking ${package} service status on the system.\n\n"
    echo -e $"Usage:\t $0 enable\nFor enabling ${package} service on boot time of the system.\n\n"
    echo -e $"Usage:\t $0 disable\nFor disabling ${package} service on boot time of the system.\n\n"
    echo -e $"Usage:\t $0 start\nFor starting ${package} service on the system.\n\n"
    echo -e $"Usage:\t $0 restart\nFor restarting ${package} service on the system.\n\n"
    echo -e $"Usage:\t $0 stop\nFor stopping ${package} service on the system.\n\n"
    echo -e $"Usage:\t $0 examples\nFor usage examples of  ${package} .\n\n"
    echo -e $"Usage:\t $0 uninstall\nFor uninstalling/purging ${package} from the system.\n"
    exit 1
esac
