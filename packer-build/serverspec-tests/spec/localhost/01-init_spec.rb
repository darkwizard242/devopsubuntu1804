require 'spec_helper'

## Check if desired motd file exists.
describe file('/etc/sudoers') do
  it { should exist }
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should be_readable.by_user('root') }
  it { should contain 'vagrant        ALL=(ALL)       NOPASSWD: ALL' }
  it { should contain 'ansible        ALL=(ALL)       NOPASSWD: ALL' }
  it { should contain 'jenkins        ALL=(ALL)       NOPASSWD: ALL' }
  it { should contain 'docker        ALL=(ALL)       NOPASSWD: ALL' }
end


## Check whether the packages in 01-init.sh are available in the system
describe package('build-essential') do
  it { should be_installed }
end

describe package('dkms') do
  it { should be_installed }
end

describe package('nfs-common') do
  it { should be_installed }
end

describe package('curl') do
  it { should be_installed }
end

describe package('wget') do
  it { should be_installed }
end

describe package('tmux') do
  it { should be_installed }
end

describe package('xvfb') do
  it { should be_installed }
end

describe package('vim') do
  it { should be_installed }
end

describe package('inxi') do
  it { should be_installed }
end

describe package('screenfetch') do
  it { should be_installed }
end

describe package('tree') do
  it { should be_installed }
end
