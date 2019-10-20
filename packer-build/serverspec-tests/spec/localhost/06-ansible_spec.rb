require 'spec_helper'


if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe ppa('ansible/ansible') do
      it { should exist }
      it { should be_enabled }
    end
    describe package('ansible') do
      it { should be_installed }
    end
    describe file('/usr/bin/ansible') do
      it { should exist }
      it { should be_file }
      it { should be_executable }
    end
    describe command('which ansible') do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should match /\/usr\/bin\/ansible/ }
    end
    describe command('ansible --version') do
      its(:exit_status) { should eq 0 }
    end
    describe command('ansible localhost -m shell -a "hostname"') do
      its(:exit_status) { should eq 0 }
    end
  end
end
