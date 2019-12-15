#!/bin/bash -e

# Shellcheck fixes for: SC2181, SC2028, SC2006

dependencies="curl apt-transport-https lsb-release gnupg"
ms_key="https://packages.microsoft.com/keys/microsoft.asc"
system_rel=$(lsb_release -cs)
azure_repo="https://packages.microsoft.com/repos/azure-cli"
package="azure-cli"


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

check_if_azure-cli_installed () {
  if az --version &> /dev/null;
    then
      echo -e "\nYES: ${package} is IN an installed state within the system.\n"
      exit 0
    else
      echo -e "\nNO: ${package} is NOT IN an installed state.\n"
  fi
}

add_azure-cli_repo () {
  echo -e "\nAdding Microsoft Key!"
  curl -sL $ms_key | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null
  echo -e "\nAdding Azure Repo to apt list!"
  echo -e "deb [arch=amd64] ${azure_repo} ${system_rel} main" > /etc/apt/sources.list.d/${package}.list
  DEBIAN_FRONTEND=non-interactive apt-get update
}

azure-cli_installer () {
  DEBIAN_FRONTEND=non-interactive apt-get install ${package} -y
}

azure-cli_uninstaller () {
  DEBIAN_FRONTEND=non-interactive apt-get purge ${package} -y
}

remove_azure-cli_repo () {
  rm -v /etc/apt/sources.list.d/${package}.list
}

azure-cli_verify () {
  if az --help &> /dev/null;
    then
      echo -e "\nExit status for ${package} command returned back with a successful exit code.\n"
    else
      echo -e "\nThere was an issue with the execution of ${package} command.\n"
      exit 2
  fi
}

case "$1" in
  check)
    check_os
    check_if_azure-cli_installed
    ;;
  install)
    check_os
    setup_dependencies
    check_if_azure-cli_installed
    echo -e "\nInstallation beginning for:\t${package}\n"
    add_azure-cli_repo
    azure-cli_installer
    azure-cli_verify
    ;;
  uninstall)
    check_os
    echo -e "\nPurging beginning for:\t${package}\n"
    azure-cli_uninstaller
    remove_azure-cli_repo
    ;;
  *)
    echo -e $"\nUsage:\t $0 check\t\t : Checks if ${package} is installed on the system and operational."
    echo -e $"Usage:\t $0 install\t\t : For installing ${package} from the system."
    echo -e $"Usage:\t $0 uninstall\t : For uninstalling/purging ${package} from the system.\n"
    exit 1
esac
