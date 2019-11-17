require 'spec_helper'

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe package('ruby') do
      it { should be_installed }
    end
    describe file('/usr/bin/ruby') do
      it { should exist }
      it { should be_symlink }
      it { should be_executable }
    end
    describe command('ruby --version') do
      its(:exit_status) { should eq 0 }
    end
    describe command('which ruby') do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should match /\/usr\/bin\/ruby/ }
    end
  end
end


if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe package('serverspec') do
      it { should be_installed.by('gem') }
    end
  end
end
