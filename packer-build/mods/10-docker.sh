#!/bin/bash -e

# Shellcheck fixes for: SC2086, SC2181, SC2006

dependencies="apt-transport-https ca-certificates curl software-properties-common"
system_rel=$(lsb_release -cs)
supporting_packages="docker-ce-cli containerd.io"
package="docker-ce"
pkg_simple="docker"

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

check_if_docker_installed () {
  if ${pkg_simple} --version &> /dev/null;
    then
      echo -e "\nYES: ${package} is IN an installed state within the system.\n"
      docker_verify
      exit 0
    else
      echo -e "\nNO: ${package} is NOT IN an installed state.\n"
  fi
}

add_docker_repo () {
  curl -fsSL https://download.${pkg_simple}.com/linux/ubuntu/gpg | apt-key add -
  echo -e "\nCreating ${package} repo file.\n"
  echo -e "deb [arch=amd64] https://download.${pkg_simple}.com/linux/ubuntu $system_rel stable" | sudo tee -a /etc/apt/sources.list.d/${package}.list
  DEBIAN_FRONTEND=non-interactive apt-get update
}

docker_installer () {
  DEBIAN_FRONTEND=non-interactive apt-get install ${package} ${supporting_packages} -y
  ver_fresh=$(${pkg_simple} --version)
  echo -e "\nInstalled ${package} version is: ${ver_fresh}"
}

remove_docker_repo () {
  rm -v /etc/apt/sources.list.d/${package}.list
}

docker_uninstaller () {
  DEBIAN_FRONTEND=non-interactive apt-get purge ${package} ${supporting_packages} -y
}

docker_verify () {
  ${pkg_simple} ps &> /dev/null
}

docker_service_status () {
  systemctl status --no-pager -l ${pkg_simple}
}

docker_service_enable () {
  systemctl enable ${pkg_simple}
}

docker_service_disable () {
  systemctl disable ${pkg_simple}
}

docker_service_start () {
  systemctl start ${pkg_simple}
}

docker_service_restart () {
  systemctl restart ${pkg_simple}
}

docker_service_stop () {
  systemctl stop ${pkg_simple}
}

case "$1" in
  check)
    check_os
    check_if_docker_installed
    docker_verify
    ;;
  install)
    check_os
    setup_dependencies
    check_if_docker_installed
    echo -e "\nInstallation beginning for:\t${package}\n"
    add_docker_repo
    docker_installer
    docker_service_enable
    docker_service_restart
    docker_verify
    ;;
  status)
    check_os
    docker_service_status
    ;;
  enable)
    check_os
    docker_service_enable
    ;;
  disable)
    check_os
    docker_service_disable
    ;;
  start)
    check_os
    docker_service_start
    ;;
  restart)
    check_os
    docker_service_restart
    ;;
  stop)
    check_os
    docker_service_stop
    ;;
  uninstall)
    check_os
    docker_service_stop
    echo -e "\nPurging beginning for:\t${package}\n"
    docker_uninstaller
    remove_docker_repo
    ;;
  *)
    echo -e $"\nUsage:\t $0 check\nChecks if ${pkg_simple} is installed on the system and operational.\n\n"
    echo -e $"Usage:\t $0 install\nFor installing ${package} from the system.\n\n"
    echo -e $"Usage:\t $0 status\nFor checking ${pkg_simple} service status on the system.\n\n"
    echo -e $"Usage:\t $0 enable\nFor enabling ${pkg_simple} service on boot time of the system.\n\n"
    echo -e $"Usage:\t $0 disable\nFor disabling ${pkg_simple} service on boot time of the system.\n\n"
    echo -e $"Usage:\t $0 start\nFor starting ${pkg_simple} service on the system.\n\n"
    echo -e $"Usage:\t $0 restart\nFor restarting ${pkg_simple} service on the system.\n\n"
    echo -e $"Usage:\t $0 stop\nFor stopping ${pkg_simple} service on the system.\n\n"
    echo -e $"Usage:\t $0 uninstall\nFor uninstalling/purging ${package}, ${supporting_packages} from the system.\n"
    exit 1
esac
