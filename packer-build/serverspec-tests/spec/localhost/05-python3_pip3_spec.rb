require 'spec_helper'

## Check for python3 package
describe package('python3'), :if => os[:family] == 'ubuntu' do
  it { should be_installed }
end

describe command('python3 --version'), :if => os[:family] == 'ubuntu' do
  its(:exit_status) { should eq 0 }
end

## Check for python3-pip package
describe package('python3-pip'), :if => os[:family] == 'ubuntu' do
  it { should be_installed }
end

describe command('pip3 --version'), :if => os[:family] == 'ubuntu' do
  its(:exit_status) { should eq 0 }
end
