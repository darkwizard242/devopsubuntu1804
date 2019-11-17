require 'spec_helper'


if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe package('apt-transport-https') do
      it { should be_installed }
    end
  end
end


if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe package('ca-certificates') do
      it { should be_installed }
    end
    describe file('/usr/sbin/update-ca-certificates') do
      it { should exist }
      it { should be_file }
      it { should be_executable }
    end
    describe command('which update-ca-certificates') do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should match /\/usr\/sbin\/update-ca-certificates/ }
    end
  end
end


if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe package('curl') do
      it { should be_installed }
    end
    describe file('/usr/bin/curl') do
      it { should exist }
      it { should be_file }
      it { should be_executable }
    end
    describe command('which curl') do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should match /\/usr\/bin\/curl/ }
    end
  end
end


if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe package('software-properties-common') do
      it { should be_installed }
    end
  end
end


if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe file('/etc/apt/sources.list.d/docker.list') do
      it { should exist }
      it { should be_file }
      it { should be_readable }
      it { should be_writable.by_user('root') }
      it { should be_mode 644 }
      its(:content) { should match /deb\ \[arch\=amd64\]\ https\:\/\/download\.docker\.com\/linux\/ubuntu\ bionic\ stable/ }
    end
    describe package('docker-ce') do
      it { should be_installed }
    end
    describe package('docker-ce-cli') do
      it { should be_installed }
    end
    describe package('containerd.io') do
      it { should be_installed }
    end
    describe service('docker') do
      it { should be_enabled }
      it { should be_running }
    end
    describe file('/usr/bin/docker') do
      it { should exist }
      it { should be_file }
      it { should be_executable }
    end
    describe file('/var/lib/docker') do
      it { should exist }
      it { should be_directory }
      it { should be_writable.by_user('root') }
      it { should be_readable.by_user('root') }
      it { should be_executable }
      it { should be_mode 711 }
    end
    describe file('/var/run/docker.sock') do
      it { should be_socket }
      it { should be_owned_by 'root' }
    end
    describe command('docker --version') do
      its(:exit_status) { should eq 0 }
    end
    describe command('which docker') do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should match /\/usr\/bin\/docker/ }
    end
    describe command('containerd --version') do
      its(:exit_status) { should eq 0 }
    end
    describe command('which containerd') do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should match /\/usr\/bin\/containerd/ }
    end
  end
end
