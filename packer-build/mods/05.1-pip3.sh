#!/bin/bash -e

# Shellcheck fixes for: SC2086, SC2181, SC2006

package1="python3"
package2="python3-pip"

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
    else
      echo -e "\nNO: ${package1} is NOT IN an installed state.\n"
      exit 2
  fi
}

check_if_pip3_installed () {
  if ${package2} --version &> /dev/null;
    then
      echo -e "\nYES: ${package2} is IN an installed state within the system.\n"
      exit 0
    else
      echo -e "\nNO: ${package2} is NOT IN an installed state.\n"
  fi
}

pip3_installer () {
  DEBIAN_FRONTEND=non-interactive apt-get install ${package2} -y
}

pip3_upgrade () {
  check_if_python3_installed
  if ${package2} --version &> /dev/null;
    then
      echo -e "\nYES: ${package2} is IN an installed state within the system. Upgrade beginning for:\t${package2}.\n"
      ${package1} -m pip install -U pip
    else
      echo -e "\nNO: ${package2} is NOT IN an installed state.\n"
      exit 2
  fi
}

pip3_uninstaller () {
  DEBIAN_FRONTEND=non-interactive apt-get purge ${package2} -y
}

case "$1" in
  check)
    check_os
    check_if_pip3_installed
    ;;
  install)
    check_os
    check_if_pip3_installed
    echo -e "\nInstallation beginning for:\t${package2}\n"
    pip3_installer
    ;;
  upgrade)
    check_os
    pip3_upgrade
    ;;
  uninstall)
    check_os
    echo -e "\nPurging beginning for:\t${package2}\n"
    pip3_uninstaller
    ;;
  *)
    echo -e $"\nUsage:\t $0 check\t\t : Checks if ${package2} is installed on the system."
    echo -e $"Usage:\t $0 install\t\t : For installing ${package2} from the system."
    echo -e $"Usage:\t $0 upgrade\t\t : For upgrading pip3 from the system."
    echo -e $"Usage:\t $0 uninstall\t\t : For uninstalling/purging ${package2} from the system.\n"
    exit 1
esac
