#!/bin/bash -e

package="jenkins"

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

check_if_jenkins_installed () {
  if dpkg -s ${package} &> /dev/null;
    then
      echo -e "\nYES: ${package} is IN an installed state within the system.\n"
      exit 0
    else
      echo -e "\nNO: ${package} is NOT IN an installed state.\n"
  fi
}

add_jenkins_repo () {
  wget -q -O - https://pkg.${package}.io/debian/${package}.io.key | sudo apt-key add -
  echo "deb http://pkg.${package}.io/debian-stable binary/" | sudo tee -a /etc/apt/sources.list.d/${package}.list
  DEBIAN_FRONTEND=non-interactive apt-get update
}

remove_jenkins_repo () {
  rm -v /etc/apt/sources.list.d/${package}.list
}

jenkins_installer () {
  DEBIAN_FRONTEND=non-interactive apt-get install ${package} -y
}

jenkins_uninstaller () {
  DEBIAN_FRONTEND=non-interactive apt-get purge ${package} -y
}

jenkins_service_status () {
  systemctl status --no-pager -l ${package}
}

jenkins_service_enable () {
  systemctl enable ${package}
}

jenkins_service_disable () {
  systemctl disable ${package}
}

jenkins_service_start () {
  systemctl start ${package}
}

jenkins_service_restart () {
  systemctl restart ${package}
}

jenkins_service_stop () {
  systemctl stop ${package}
}

case "$1" in
  check)
    check_os
    check_if_jenkins_installed
    ;;
  install)
    check_os
    check_if_jenkins_installed
    echo -e "\nInstallation beginning for:\t${package}\n"
    add_jenkins_repo
    jenkins_installer
    jenkins_service_enable
    jenkins_service_restart
    ;;
  status)
    check_os
    jenkins_service_status
    ;;
  enable)
    check_os
    jenkins_service_enable
    ;;
  disable)
    check_os
    jenkins_service_disable
    ;;
  start)
    check_os
    jenkins_service_start
    ;;
  restart)
    check_os
    jenkins_service_restart
    ;;
  stop)
    check_os
    jenkins_service_stop
    ;;
  uninstall)
    check_os
    jenkins_service_stop
    echo -e "\nPurging beginning for:\t${package}\n"
    jenkins_uninstaller
    remove_jenkins_repo
    ;;
  *)
    echo -e $"\nUsage:\t $0 check\t\t : Checks if ${package} is installed on the system and operational."
    echo -e $"Usage:\t $0 install\t\t : For installing ${package} on the system."
    echo -e $"Usage:\t $0 status\t\t : For checking ${package} service status on the system."
    echo -e $"Usage:\t $0 enable\t\t : For enabling ${package} service on boot time of the system."
    echo -e $"Usage:\t $0 disable\t\t : For disabling ${package} service on boot time of the system."
    echo -e $"Usage:\t $0 start\t\t : For starting ${package} service on the system."
    echo -e $"Usage:\t $0 restart\t\t : For restarting ${package} service on the system."
    echo -e $"Usage:\t $0 stop\t\t : For stopping ${package} service on the system."
    echo -e $"Usage:\t $0 uninstall\t\t : For uninstalling/purging ${package} from the system.\n"
    exit 1
esac
