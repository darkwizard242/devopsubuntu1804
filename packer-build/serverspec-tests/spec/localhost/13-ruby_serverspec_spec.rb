require 'spec_helper'

describe package('ruby'), :if => os[:family] == 'ubuntu' do
  it { should be_installed }
end

describe command('ruby --version'), :if => os[:family] == 'ubuntu' do
  its(:exit_status) { should eq 0 }
end

describe package('serverspec'), :if => os[:family] == 'ubuntu' do
  it { should be_installed.by('gem') }
end
