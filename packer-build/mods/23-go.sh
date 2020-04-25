#!/bin/bash -e

dependencies="wget git"
package="go"
version="1.14.2"
osarch="linux-amd64"
extract_path="/usr/local"
export_template_path="/etc/profile.d"

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

function go_export_template () {
  cat <<EOF >${export_template_path}/${package}.sh
# System-wide export for GO
export PATH=$PATH:/usr/local/go/bin
EOF
chmod 0644 -v ${export_template_path}/${package}.sh
}

function add_go_profile_export () {
  if [ -f "${export_template_path}/${package}.sh" ];
    then
      echo -e "\nRemoving pre-existing ${package} system-wide export file:\t${export_template_path}/${package}.sh\n"

      echo -e "\nCreating ${package} system-wide export file:\t${export_template_path}/${package}.sh\n"
      go_export_template
    else
      echo -e "\nCreating ${package} system-wide export file:\t${export_template_path}/${package}.sh\n"
      go_export_template
  fi
}

function remove_go_profile_export () {
  if [ -f "${export_template_path}/${package}.sh" ];
    then
      echo -e "\nRemoving ${package} system-wide export file:\t${export_template_path}/${package}.sh\n"
      rm -rfv ${export_template_path}/${package}.sh
    else
      echo -e "\n${package} system-wide export file:\t${export_template_path}/${package}.sh\tdoes not exist.\n"
  fi
}

function go_installer () {
  wget -v -O /tmp/${package}.tar.gz https://dl.google.com/${package}/${package}${version}.${osarch}.tar.gz &> /dev/null
  tar -xzf /tmp/${package}.tar.gz -C ${extract_path}  && rm -rv /tmp/${package}.tar.gz
  chmod -v 0755 ${extract_path}/${package}
}

function go_uninstaller () {
  rm -rf ${extract_path}/${package}
}

case "$1" in
  install)
    check_os
    echo -e "\nInstallation beginning for:\t${package}\n"
    go_installer
    add_go_profile_export
    ;;
  uninstall)
    check_os
    echo -e "\nPurging beginning for:\t${package}\n"
    go_uninstaller
    remove_go_profile_export
    ;;
  *)
    echo -e $"Usage:\t $0 install\nFor installing ${package} from the system.\n\n"
    echo -e $"Usage:\t $0 uninstall\nFor uninstalling/purging ${package} from the system.\n\n"
    exit 1
esac
