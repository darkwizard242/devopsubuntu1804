#!/bin/bash -e

# Shellcheck fixes for: SC2181

sdk_rel="cloud-sdk-$(lsb_release -cs)"
package="google-cloud-sdk"


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

check_if_google-cloud-sdk_installed () {
  if gcloud --version &> /dev/null;
    then
      echo -e "\nYES: ${package} is IN an installed state within the system.\n"
      exit 0
    else
      echo -e "\nNO: ${package} is NOT IN an installed state.\n"
  fi
}

add_google-cloud-sdk_repo () {
  echo -e "\nAdding ${package} key and repo to apt list!"
  curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
  echo -e "deb http://packages.cloud.google.com/apt ${sdk_rel} main" | sudo tee -a /etc/apt/sources.list.d/${package}.list
  DEBIAN_FRONTEND=non-interactive apt-get update
}

google-cloud-sdk_installer () {
  DEBIAN_FRONTEND=non-interactive apt-get install ${package} -y
}

google-cloud-sdk_uninstaller () {
  DEBIAN_FRONTEND=non-interactive apt-get purge ${package} -y
}

remove_google-cloud-sdk_repo () {
  rm -v /etc/apt/sources.list.d/${package}.list
}

google-cloud-sdk_verify () {
  if gcloud --help &> /dev/null;
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
    check_if_google-cloud-sdk_installed
    ;;
  install)
    check_os
    check_if_google-cloud-sdk_installed
    echo -e "\nInstallation beginning for:\t${package}\n"
    add_google-cloud-sdk_repo
    google-cloud-sdk_installer
    google-cloud-sdk_verify
    ;;
  uninstall)
    check_os
    echo -e "\nPurging beginning for:\t${package}\n"
    google-cloud-sdk_uninstaller
    remove_google-cloud-sdk_repo
    ;;
  *)
    echo -e $"\nUsage:\t $0 check\t : Checks if ${package} is installed on the system and operational."
    echo -e $"Usage:\t $0 install\t : For installing ${package} from the system."
    echo -e $"Usage:\t $0 uninstall\t : For uninstalling/purging ${package} from the system.\n"
    exit 1
esac
