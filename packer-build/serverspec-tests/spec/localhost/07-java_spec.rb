require 'spec_helper'


describe package('openjdk-8-jdk'), :if => os[:family] == 'ubuntu' do
  it { should be_installed }
end

describe command('java -version'), :if => os[:family] == 'ubuntu' do
  its(:exit_status) { should eq 0 }
end
