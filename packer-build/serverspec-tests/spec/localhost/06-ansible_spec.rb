require 'spec_helper'

describe ppa('ansible/ansible') do
  it { should exist }
  it { should be_enabled }
end

describe package('ansible') do
  it { should be_installed }
end

describe command('ansible --version') do
  its(:exit_status) { should eq 0 }
end
