require 'spec_helper'


describe file('/etc/apt/sources.list'), :if => os[:family] == 'ubuntu' do
  it { should be_file }
  it { should contain 'deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable' }
end

describe package('docker-ce'), :if => os[:family] == 'ubuntu' do
  it { should be_installed }
end

describe service('docker'), :if => os[:family] == 'ubuntu' do
  it { should be_enabled }
  it { should be_running }
end

describe file('/var/run/docker.sock'), :if => os[:family] == 'ubuntu' do
  it { should be_socket }
  it { should be_owned_by 'root' }
end

describe command('docker --version'), :if => os[:family] == 'ubuntu' do
  its(:exit_status) { should eq 0 }
end
