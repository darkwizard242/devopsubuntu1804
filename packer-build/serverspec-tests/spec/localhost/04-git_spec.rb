require 'spec_helper'


if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe package('git') do
      it { should be_installed }
    end
    describe file('/usr/bin/git') do
      it { should exist }
      it { should be_file }
      it { should be_executable }
    end
    describe command('git --version') do
      its(:exit_status) { should eq 0 }
    end
    describe command('which git') do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should match /\/usr\/bin\/git/ }
    end
  end
end
