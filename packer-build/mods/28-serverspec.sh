#!/bin/bash -e

# Shellcheck fixes for: SC2086, SC2181, SC2006

package1="ruby"
package2="serverspec"

function check_os () {
  if [ "$(grep -Ei 'VERSION_ID="16.04"' /etc/os-release)" ];
  then
    echo -e "\nSystem OS is Ubuntu. Version is 16.04.\n\n###\tProceeding with SCRIPT Execution\t###\n"
  elif [ "$(grep -Ei 'VERSION_ID="18.04"' /etc/os-release)" ];
  then
    echo -e "\nSystem OS is Ubuntu. Version is 18.04.\n\n###\tProceeding with SCRIPT Execution\t###\n"
  elif [ "$(grep -Ei 'VERSION_ID="20.04"' /etc/os-release)" ];
  then
    echo -e "\nSystem OS is Ubuntu. Version is 20.04.\n\n###\tProceeding with SCRIPT Execution\t###\n"
  else
    echo -e "\nThis is neither Ubuntu 16.04, Ubuntu 18.04 or Ubuntu 20.04.\n\n###\tScript execution HALTING!\t###\n"
    exit 2
  fi
}

function check_if_ruby_installed () {
  if ${package1} --version &> /dev/null;
    then
      echo -e "\nYES: ${package1} is IN an installed state within the system. It is required to install ${package2}\n"
    else
      echo -e "\nNO: ${package1} is NOT IN an installed state. It is required to install ${package2}\n"
      exit 2
  fi
}

function check_if_serverspec_installed () {
  if which ${package2}-init &> /dev/null;
    then
      echo -e "\nYES: ${package2} is IN an installed state within the system.\n"
      exit 0
    else
      echo -e "\nNO: ${package2} is NOT IN an installed state.\n"
  fi
}

function serverspec_installer () {
  gem install ${package2}
}

function serverspec_uninstaller () {
  gem uninstall ${package2} -x
}


case "$1" in
  check)
    check_os
    check_if_serverspec_installed
    ;;
  install)
    check_os
    check_if_ruby_installed
    check_if_serverspec_installed
    echo -e "\nInstallation beginning for:\t${package2}\n"
    serverspec_installer
    ;;
  uninstall)
    check_os
    echo -e "\nPurging beginning for:\t${package2}\n"
    serverspec_uninstaller
    ;;
  *)
    echo -e $"\nUsage:\t $0 check\t\t\t : Checks if ${package2} is installed on the system."
    echo -e $"Usage:\t $0 install\t\t : For installing ${package2} from the system."
    echo -e $"Usage:\t $0 uninstall\t\t : For uninstalling/purging ${package2} from the system.\n"
    exit 1
esac
