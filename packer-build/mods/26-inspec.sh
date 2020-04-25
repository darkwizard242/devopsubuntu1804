#!/bin/bash -e

# Shellcheck fixes for: SC2181

dependencies="wget"
package="inspec"
version="4.18.104"

function check_os () {
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


function setup_dependencies () {
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

function check_if_inspec_installed () {
  if inspec --version &> /dev/null;
    then
      echo -e "\nYES: ${package} is IN an installed state within the system.\n"
      exit 0
    else
      echo -e "\nNO: ${package} is NOT IN an installed state.\n"
  fi
}

function inspec_downloader () {
  if [ "$(grep -Ei 'VERSION_ID="16.04"' /etc/os-release)" ];
  then
    wget -v -O /tmp/${package}_${version}-1_amd64.deb https://packages.chef.io/files/stable/${package}/${version}/ubuntu/16.04/${package}_${version}-1_amd64.deb &> /dev/null
  elif [ "$(grep -Ei 'VERSION_ID="18.04"' /etc/os-release)" ];
  then
    wget -v -O /tmp/${package}_${version}-1_amd64.deb https://packages.chef.io/files/stable/${package}/${version}/ubuntu/18.04/${package}_${version}-1_amd64.deb &> /dev/null
  else
    echo -e "\nThis is neither Ubuntu 16.04 or Ubuntu 18.04.\n\n###\tScript execution HALTING!\t###\n"
    exit 2
  fi
}

function inspec_installer () {
  DEBIAN_FRONTEND=non-interactive dpkg -i /tmp/${package}_${version}-1_amd64.deb
  rm -v /tmp/${package}_${version}-1_amd64.deb
  inspec version --chef-license=accept
}

function inspec_uninstaller () {
  DEBIAN_FRONTEND=non-interactive dpkg --purge ${package}
}


case "$1" in
  check)
    check_os
    check_if_inspec_installed
    ;;
  install)
    check_os
    check_if_inspec_installed
    echo -e "\nInstallation beginning for:\t${package}\n"
    inspec_downloader
    inspec_installer
    ;;
  uninstall)
    check_os
    echo -e "\nPurging beginning for:\t${package}\n"
    inspec_uninstaller
    ;;
  *)
    echo -e $"\nUsage:\t $0 check\nChecks if ${package} is installed on the system.\n\n"
    echo -e $"Usage:\t $0 install\nFor installing ${package} from the system.\n\n"
    echo -e $"Usage:\t $0 uninstall\nFor uninstalling/purging ${package} from the system.\n"
    exit 1
esac
