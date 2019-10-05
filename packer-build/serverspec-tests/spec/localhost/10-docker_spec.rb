require 'spec_helper'


if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe file('/etc/apt/sources.list.d/docker.list') do
      it { should be_file }
      it { should contain 'deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable' }
    end
  end
end

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe package('docker-ce') do
      it { should be_installed }
    end
  end
end

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe service('docker') do
      it { should be_enabled }
      it { should be_running }
    end
  end
end

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe file('/var/run/docker.sock') do
      it { should be_socket }
      it { should be_owned_by 'root' }
    end
  end
end

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe command('docker --version') do
      its(:exit_status) { should eq 0 }
    end
  end
end
