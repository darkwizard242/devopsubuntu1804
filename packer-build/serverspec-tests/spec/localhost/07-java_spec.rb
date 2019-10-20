require 'spec_helper'


if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe package('openjdk-8-jdk') do
        it { should be_installed }
    end
    describe file('/usr/bin/java') do
      it { should exist }
      it { should be_file }
      it { should be_symlink }
      it { should be_executable }
    end
    describe command('which java') do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should match /\/usr\/bin\/java/ }
    end
    describe command('java -version') do
      its(:exit_status) { should eq 0 }
    end
  end
end
