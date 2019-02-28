require 'spec_helper'

## Check for python3 package
describe package('python3') do
  it { should be_installed }
end

describe command('python3 --version') do
  its(:exit_status) { should eq 0 }
end

## Check for python3-pip package
describe package('python3-pip') do
  it { should be_installed }
end

describe command('pip3 --version') do
  its(:exit_status) { should eq 0 }
end
