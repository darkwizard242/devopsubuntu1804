#!/bin/bash -e

# Shellcheck fixes for: SC2181, SC2006

dependencies="wget tar"
package="hugo"
version="0.68.3"
osarch="Linux-64bit"
extract_path="/usr/local/bin"

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

check_if_hugo_installed () {
  if command -v ${package} &> /dev/null;
    then
      echo -e "\nYES: ${package} is IN an installed state within the system.\n"
      exit 0
    else
      echo -e "\nNO: ${package} is NOT IN an installed state.\n"
  fi
}

hugo_downloader () {
  wget -v -O /tmp/${package}.tar.gz https://github.com/gohugoio/${package}/releases/download/v${version}/${package}_extended_${version}_${osarch}.tar.gz &> /dev/null
}

hugo_extractor () {
  tar -xf /tmp/${package}.tar.gz -C ${extract_path}/ ${package} &> /dev/null && rm -rv /tmp/${package}.tar.gz
}

hugo_removal () {
  rm -v ${extract_path}/${package}
}


case "$1" in
  check)
    check_os
    check_if_hugo_installed
    ;;
  install)
    check_os
    setup_dependencies
    check_if_hugo_installed
    echo -e "\nInstallation beginning for:\t${package}\n"
    hugo_downloader
    hugo_extractor
    ;;
  uninstall)
    check_os
    echo -e "\nPurging beginning for:\t${package}\n"
    hugo_removal
    ;;
  *)
    echo -e $"\nUsage:\t $0 check\nChecks if ${package} is installed on the system and operational.\n\n"
    echo -e $"Usage:\t $0 install\nFor installing ${package} from the system.\n\n"
    echo -e $"Usage:\t $0 uninstall\nFor uninstalling/purging ${package} from the system.\n"
    exit 1
esac
