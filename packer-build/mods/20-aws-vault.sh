#!/bin/bash -e

# Shellcheck fixes for: SC2181, SC2006, SC2140

dependencies="curl"
version="5.4.1"
osarch="linux-amd64"
package="aws-vault"
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

function check_if_aws-vault_installed () {
  if command -v ${package} &> /dev/null;
    then
      echo -e "\nYES: ${package} is IN an installed state within the system.\n"
      exit 0
    else
      echo -e "\nNO: ${package} is NOT IN an installed state.\n"
  fi
}

function add_aws-vault_profile_export () {
  echo -e "\n\nexport AWS_VAULT_BACKEND=\"file\"" >> "$HOME"/.bashrc
}

function remove_aws-vault_profile_export () {
  sed -i "s/export\ AWS\_VAULT\_BACKEND\=\"file\"//g" "$HOME"/.bashrc
}

function aws-vault_installer () {
  curl -L -o ${extract_path}/${package} https://github.com/99designs/${package}/releases/download/v${version}/${package}-${osarch} &> /dev/null
  chmod -v 0755 ${extract_path}/${package}
}

function aws-vault_uninstaller () {
  rm -v ${extract_path}/${package}
}

case "$1" in
  check)
    check_os
    check_if_aws-vault_installed
    ;;
  install)
    check_os
    check_if_aws-vault_installed
    echo -e "\nInstallation beginning for:\t${package}\n"
    aws-vault_installer
    add_aws-vault_profile_export
    ;;
  uninstall)
    check_os
    echo -e "\nPurging beginning for:\t${package}\n"
    aws-vault_uninstaller
    remove_aws-vault_profile_export
    ;;
  *)
    echo -e $"\nUsage:\t $0 check\nChecks if ${package} is installed on the system.\n\n"
    echo -e $"Usage:\t $0 install\nFor installing ${package} from the system.\n\n"
    echo -e $"Usage:\t $0 uninstall\nFor uninstalling/purging ${package} from the system.\n\n"
    exit 1
esac
