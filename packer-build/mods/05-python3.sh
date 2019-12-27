#!/bin/bash -e

# Shellcheck fixes for: SC2086, SC2181, SC2006

package1="python3"

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

check_if_python3_installed () {
  if ${package1} --version &> /dev/null;
    then
      echo -e "\nYES: ${package1} is IN an installed state within the system.\n"
      exit 0
    else
      echo -e "\nNO: ${package1} is NOT IN an installed state.\n"
  fi
}

python3_installer () {
  DEBIAN_FRONTEND=non-interactive apt-get install ${package1} -y
}

python3_uninstaller () {
  DEBIAN_FRONTEND=non-interactive apt-get purge ${package1} -y
}

case "$1" in
  check)
    check_os
    check_if_python3_installed
    ;;
  install)
    check_os
    check_if_python3_installed
    echo -e "\nInstallation beginning for:\t${package1}\n"
    python3_installer
    ;;
  uninstall)
    check_os
    echo -e "\nPurging beginning for:\t${package1}\n"
    python3_uninstaller
    ;;
  *)
    echo -e $"\nUsage:\t $0 check\nChecks if ${package1} is installed on the system.\n\n"
    echo -e $"Usage:\t $0 install\nFor installing ${package1} from the system.\n\n"
    echo -e $"Usage:\t $0 uninstall\nFor uninstalling/purging ${package1} from the system.\n"
    exit 1
esac
