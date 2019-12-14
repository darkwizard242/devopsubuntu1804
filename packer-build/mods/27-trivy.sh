#!/bin/bash -e

dependencies="wget apt-transport-https gnupg lsb-release"
system_rel=$(lsb_release -cs)
package="trivy"

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

check_if_trivy_installed () {
  if ${package} --version &> /dev/null;
    then
      echo -e "\nYES: ${package} is IN an installed state within the system.\n"
      trivy_verify
      exit 0
    else
      echo -e "\nNO: ${package} is NOT IN an installed state.\n"
  fi
}

add_trivy_repo () {
  wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
  echo -e "\nCreating ${package} repo file.\n"
  echo -e "deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main"  > /etc/apt/sources.list.d/${package}.list
  echo deb https://aquasecurity.github.io/trivy-repo/deb ${system_rel} main > /etc/apt/sources.list.d/${package}.list
  DEBIAN_FRONTEND=non-interactive apt-get update
}

trivy_installer () {
  DEBIAN_FRONTEND=non-interactive apt-get install ${package} -y
}

remove_trivy_repo () {
  rm -v /etc/apt/sources.list.d/${package}.list
}

trivy_uninstaller () {
  DEBIAN_FRONTEND=non-interactive apt-get purge ${package} -y
}


case "$1" in
  check)
    check_os
    check_if_trivy_installed
    ;;
  install)
    check_os
    setup_dependencies
    check_if_trivy_installed
    echo -e "\nInstallation beginning for:\t${package}\n"
    add_trivy_repo
    trivy_installer
    ;;
  uninstall)
    check_os
    echo -e "\nPurging beginning for:\t${package}\n"
    trivy_uninstaller
    remove_trivy_repo
    ;;
  *)
    echo -e $"\nUsage:\t $0 check\t\t : Checks if ${package} is installed on the system and operational."
    echo -e $"Usage:\t $0 install\t\t : For installing ${package} from the system."
    echo -e $"Usage:\t $0 uninstall\t\t : For uninstalling/purging ${package} from the system.\n"
    exit 1
esac
