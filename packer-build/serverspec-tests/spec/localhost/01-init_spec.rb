require 'spec_helper'

## Check sudoers ownership, perms, file exists, contents.
if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe file('/etc/sudoers') do
      it { should exist }
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_readable.by_user('root') }
      it { should be_mode 440 }
      its(:content) { should match /vagrant\ ALL\=\(ALL\)\ NOPASSWD:\ ALL/ }
      its(:content) { should match /ansible\ ALL\=\(ALL\)\ NOPASSWD\:\ ALL/ }
      its(:content) { should match /jenkins\ ALL\=\(ALL\)\ NOPASSWD\:\ ALL/ }
      its(:content) { should match /docker\ ALL\=\(ALL\)\ NOPASSWD\:\ ALL/ }
    end
  end
end


## Check for file to disable unattended updates - ownership, perms, file exists, contents.
if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe file('/etc/apt/apt.conf.d/10periodic') do
      it { should exist }
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_readable.by_user('root') }
      it { should be_writable.by_user('root') }
      it { should be_readable }
      it { should be_mode 644 }
      its(:content) { should match /APT\:\:Periodic\:\:Enable\ \"0\"\;/ }
    end
  end
end


## Check whether the packages in 01-init.sh are available in the system
if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe package('build-essential') do
      it { should be_installed }
    end
  end
end


if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe package('dkms') do
      it { should be_installed }
    end
    describe file('/usr/sbin/dkms') do
      it { should exist }
      it { should be_file }
      it { should be_executable }
    end
    describe command('which dkms') do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should match /\/usr\/sbin\/dkms/ }
    end
  end
end


if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe package('nfs-common') do
      it { should be_installed }
    end
    describe file('/usr/share/nfs-common') do
      it { should exist }
      it { should be_directory }
      it { should be_executable }
    end
    describe command('whereis nfs-common') do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should match /\/usr\/share\/nfs\-common/ }
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
    describe package('wget') do
      it { should be_installed }
    end
    describe file('/usr/bin/wget') do
      it { should exist }
      it { should be_file }
      it { should be_executable }
    end
    describe command('which wget') do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should match /\/usr\/bin\/wget/ }
    end
  end
end


if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe package('tmux') do
      it { should be_installed }
    end
    describe file('/usr/bin/tmux') do
      it { should exist }
      it { should be_file }
      it { should be_executable }
    end
    describe command('which tmux') do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should match /\/usr\/bin\/tmux/ }
    end
  end
end


if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe package('xvfb') do
      it { should be_installed }
    end
  end
end


if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe package('vim') do
      it { should be_installed }
    end
    describe file('/usr/bin/vim') do
      it { should exist }
      it { should be_symlink }
      it { should be_executable }
    end
    describe command('which vim') do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should match /\/usr\/bin\/vim/ }
    end
  end
end


if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe package('inxi') do
      it { should be_installed }
    end
    describe file('/usr/bin/inxi') do
      it { should exist }
      it { should be_file }
      it { should be_executable }
    end
    describe command('which inxi') do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should match /\/usr\/bin\/inxi/ }
    end
  end
end


if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe package('screenfetch') do
      it { should be_installed }
    end
    describe file('/usr/bin/screenfetch') do
      it { should exist }
      it { should be_file }
      it { should be_executable }
    end
    describe command('which screenfetch') do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should match /\/usr\/bin\/screenfetch/ }
    end
  end
end


if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe package('tree') do
      it { should be_installed }
    end
    describe file('/usr/bin/tree') do
      it { should exist }
      it { should be_file }
      it { should be_executable }
    end
    describe command('which tree') do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should match /\/usr\/bin\/tree/ }
    end
  end
end
