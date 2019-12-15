#!/bin/bash -e

# Shellcheck fixes for: SC2181, SC2028

package="ruby"

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

check_if_ruby_installed () {
  if ${package} --version &> /dev/null;
    then
      echo -e "\nYES: ${package} is IN an installed state within the system.\n"
      exit 0
    else
      echo -e "\nNO: ${package} is NOT IN an installed state.\n"
  fi
}

ruby_installer () {
  DEBIAN_FRONTEND=non-interactive apt-get install ${package} -y
}

ruby_uninstaller () {
  DEBIAN_FRONTEND=non-interactive apt-get purge ${package} -y
}


case "$1" in
  check)
    check_os
    check_if_ruby_installed
    ;;
  install)
    check_os
    check_if_ruby_installed
    echo -e "\nInstallation beginning for:\t${package}\n"
    ruby_installer
    ;;
  uninstall)
    check_os
    echo -e "\nPurging beginning for:\t${package}\n"
    ruby_uninstaller
    ;;
  *)
    echo -e $"\nUsage:\t $0 check\t\t : Checks if ${package} is installed on the system."
    echo -e $"Usage:\t $0 install\t\t : For installing ${package} from the system."
    echo -e $"Usage:\t $0 uninstall\t\t : For uninstalling/purging ${package} from the system.\n"
    exit 1
esac
