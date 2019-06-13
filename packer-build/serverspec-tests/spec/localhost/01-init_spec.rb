require 'spec_helper'

## Check sudoers ownership, perms, file exists, contents.
describe file('/etc/sudoers'), :if => os[:family] == 'ubuntu' do
  it { should exist }
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should be_readable.by_user('root') }
  it { should contain 'vagrant ALL=(ALL) NOPASSWD: ALL' }
  it { should contain 'ansible ALL=(ALL) NOPASSWD: ALL' }
  it { should contain 'jenkins ALL=(ALL) NOPASSWD: ALL' }
  it { should contain 'docker ALL=(ALL) NOPASSWD: ALL' }
end

## Check for file to disable unattended updates - ownership, perms, file exists, contents.
describe file('/etc/apt/apt.conf.d/10periodic'), :if => os[:family] == 'ubuntu' do
  it { should exist }
  it { should be_file }
  it { should be_owned_by 'root' }
end

## Check whether the packages in 01-init.sh are available in the system
describe package('build-essential'), :if => os[:family] == 'ubuntu' do
  it { should be_installed }
end

describe package('dkms'), :if => os[:family] == 'ubuntu' do
  it { should be_installed }
end

describe package('nfs-common'), :if => os[:family] == 'ubuntu' do
  it { should be_installed }
end

describe package('curl'), :if => os[:family] == 'ubuntu' do
  it { should be_installed }
end

describe package('wget'), :if => os[:family] == 'ubuntu' do
  it { should be_installed }
end

describe package('tmux'), :if => os[:family] == 'ubuntu' do
  it { should be_installed }
end

describe package('xvfb'), :if => os[:family] == 'ubuntu' do
  it { should be_installed }
end

describe package('vim'), :if => os[:family] == 'ubuntu' do
  it { should be_installed }
end

describe package('inxi'), :if => os[:family] == 'ubuntu' do
  it { should be_installed }
end

describe package('screenfetch'), :if => os[:family] == 'ubuntu' do
  it { should be_installed }
end

describe package('tree'), :if => os[:family] == 'ubuntu' do
  it { should be_installed }
end
