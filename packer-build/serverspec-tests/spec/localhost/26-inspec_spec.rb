require 'spec_helper'


if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe package('inspec') do
      it { should be_installed }
    end
  end
end


if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe file('/usr/bin/inspec') do
      it { should be_symlink }
      it { should be_owned_by 'root' }
    end
  end
end


if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe file('/opt/inspec') do
      it { should be_directory }
      it { should be_owned_by 'root' }
    end
  end
end


if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe command('inspec --version') do
      its(:exit_status) { should eq 0 }
    end
    describe command('which inspec') do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should match /\/usr\/bin\/inspec/ }
    end
  end
end
