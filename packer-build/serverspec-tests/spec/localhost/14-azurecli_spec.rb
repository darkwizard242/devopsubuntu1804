require 'spec_helper'


describe file('/etc/apt/sources.list.d/azure-cli.list') do
  it { should be_file }
  it { should contain 'deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli bionic main' }
end

describe package('azure-cli') do
  it { should be_installed }
end

describe file('/usr/bin/az') do
  it { should be_file }
end

describe command('az --version') do
  its(:exit_status) { should eq 0 }
end
