require 'spec_helper'

## Check if jenkins package is installed.
describe package('jenkins'), :if => os[:family] == 'ubuntu' do
  it { should be_installed }
end

## Check if jenkins service is enabled and running.
describe service('jenkins'), :if => os[:family] == 'ubuntu' do
  it { should be_enabled }
  it { should be_running }
end

## Check if listening on port 8080.
describe port(8080), :if => os[:family] == 'ubuntu' do
  it { should be_listening }
end

## Check if the jenkins directory exists.
describe file('/var/lib/jenkins'), :if => os[:family] == 'ubuntu' do
  it { should be_directory }
end

## Check if jenkins directory is owned by user jenkins.
describe file('/var/lib/jenkins'), :if => os[:family] == 'ubuntu' do
  it { should be_owned_by 'jenkins' }
end

