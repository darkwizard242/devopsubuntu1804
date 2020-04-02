#!/bin/bash -eu

serverspec_dest_dir="/opt/serverspec-tests"

## Rsync serverspec-tests directory to /opt and change ownership & permissions
## Execute ServerSpec tests for devopsubuntu1804
rsync -avzh /home/vagrant/serverspec-tests /opt/
rm -rfv /home/vagrant/serverspec-tests
chown -Rv root:root /opt/serverspec-tests
cd ${serverspec_dest_dir}

if [ "$PWD" = "$serverspec_dest_dir" ];
  then
    echo -e "\n\tCurrent Directory is: $PWD \n"
    echo -e "\n\tExecuting ServerSpec tests: \n"
    rake spec:localhost
  else
    echo -e "\nCurrent Directory is $PWD and not the correct directory to run server-spec tests in!\n"
    echo -e "\nChanging to desired directory: serverspec_dest_dir \n" && cd ${serverspec_dest_dir}
    echo -e "\n\tCurrent Directory is: $PWD \n"
    echo -e "\n\tExecuting ServerSpec tests: \n"
    rake spec:localhost
fi
