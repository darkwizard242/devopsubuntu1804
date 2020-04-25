#!/bin/bash -e


dependencies="wget unzip"
package="packer"
version="1.5.5"
osarch="linux_amd64"
extract_path="/usr/local/bin"

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

## Installing packages required for Terraform
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

function check_if_packer_installed () {
  if ${package} --version &> /dev/null;
    then
      echo -e "\nYES: ${package} is IN an installed state within the system.\n"
      exit 0
    else
      echo -e "\nNO: ${package} is NOT IN an installed state.\n"
  fi
}

function packer_downloader () {
  wget -v -O /tmp/${package}.zip https://releases.hashicorp.com/${package}/${version}/${package}_${version}_${osarch}.zip &> /dev/null
}

function packer_extractor () {
  unzip /tmp/${package}.zip -d ${extract_path}  &> /dev/null && rm -rv /tmp/${package}.zip
  ver_fresh=$(${package} --version)
  echo -e "\nInstalled ${package} version is: ${ver_fresh}"
}

function packer_removal () {
  rm -v ${extract_path}/${package}
}


case "$1" in
  check)
    check_os
    check_if_packer_installed
    ;;
  install)
    check_os
    setup_dependencies
    check_if_packer_installed
    echo -e "\nInstallation beginning for:\t${package}\n"
    packer_downloader
    packer_extractor
    ;;
  uninstall)
    check_os
    echo -e "\nPurging beginning for:\t${package}\n"
    packer_removal
    ;;
  *)
    echo -e $"\nUsage:\t $0 check\nChecks if ${package} is installed on the system and operational.\n\n"
    echo -e $"Usage:\t $0 install\nFor installing ${package} from the system.\n\n"
    echo -e $"Usage:\t $0 uninstall\nFor uninstalling/purging ${package} from the system.\n"
    exit 1
esac
