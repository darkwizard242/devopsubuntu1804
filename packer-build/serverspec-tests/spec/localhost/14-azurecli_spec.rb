require 'spec_helper'


if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe file('/etc/apt/sources.list.d/azure-cli.list') do
      it { should be_file }
      it { should contain 'deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli bionic main' }
    end
  end
end

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe package('azure-cli') do
      it { should be_installed }
    end
  end
end

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe file('/usr/bin/az') do
      it { should be_file }
    end
  end
end

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe command('az --version') do
      its(:exit_status) { should eq 0 }
    end
  end
end
