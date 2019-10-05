require 'spec_helper'

## Check sudoers ownership, perms, file exists, contents.
if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe file('/etc/sudoers') do
      it { should exist }
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_readable.by_user('root') }
      it { should contain 'vagrant ALL=(ALL) NOPASSWD: ALL' }
      it { should contain 'ansible ALL=(ALL) NOPASSWD: ALL' }
      it { should contain 'jenkins ALL=(ALL) NOPASSWD: ALL' }
      it { should contain 'docker ALL=(ALL) NOPASSWD: ALL' }
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
  end
end

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe package('nfs-common') do
      it { should be_installed }
    end
  end
end

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe package('curl') do
      it { should be_installed }
    end
  end
end

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe package('wget') do
      it { should be_installed }
    end
  end
end

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe package('tmux') do
      it { should be_installed }
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
  end
end

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe package('inxi') do
      it { should be_installed }
    end
  end
end

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe package('screenfetch') do
      it { should be_installed }
    end
  end
end

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe package('tree') do
      it { should be_installed }
    end
  end
end
