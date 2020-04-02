require 'spec_helper'

## Check for python3 package
if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe package('python3') do
      it { should be_installed }
    end
    describe file('/usr/bin/python3') do
      it { should exist }
      it { should be_file }
      it { should be_symlink }
      it { should be_executable }
    end
    describe command('python3 --version') do
      its(:exit_status) { should eq 0 }
    end
    describe command('which python3') do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should match /\/usr\/bin\/python3/ }
    end
  end
end


## Check for python3-pip package
if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe package('python3-pip') do
      it { should be_installed }
    end
    describe file('/usr/bin/pip3') do
      it { should exist }
      it { should be_file }
      it { should be_executable }
    end
    describe command('pip3 --version') do
      its(:exit_status) { should eq 0 }
    end
    describe command('which pip3') do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should match /\/usr\/bin\/pip3/ }
    end
  end
end
