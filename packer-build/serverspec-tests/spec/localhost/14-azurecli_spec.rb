require 'spec_helper'

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
    describe package('apt-transport-https') do
      it { should be_installed }
    end
  end
end


if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe package('lsb-release') do
      it { should be_installed }
    end
  end
end


if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe package('gnupg') do
      it { should be_installed }
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
    describe file('/etc/apt/sources.list.d/azure-cli.list') do
      it { should exist }
      it { should be_file }
      it { should be_readable }
      it { should be_writable.by_user('root') }
      it { should be_mode 644 }
      its(:content) { should match /deb\ \[arch\=amd64\]\ https\:\/\/packages\.microsoft\.com\/repos\/azure\-cli\ bionic\ main/ }
    end
    describe package('azure-cli') do
      it { should be_installed }
    end
    describe file('/usr/bin/az') do
      it { should exist }
      it { should be_file }
      it { should be_executable }
    end
    describe command('az --version') do
      its(:exit_status) { should eq 0 }
    end
    describe command('which az') do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should match /\/usr\/bin\/az/ }
    end
  end
end
