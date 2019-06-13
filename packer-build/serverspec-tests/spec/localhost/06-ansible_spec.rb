require 'spec_helper'

describe ppa('ansible/ansible'), :if => os[:family] == 'ubuntu' do
  it { should exist }
  it { should be_enabled }
end

describe package('ansible'), :if => os[:family] == 'ubuntu' do
  it { should be_installed }
end

describe command('ansible --version'), :if => os[:family] == 'ubuntu' do
  its(:exit_status) { should eq 0 }
end
