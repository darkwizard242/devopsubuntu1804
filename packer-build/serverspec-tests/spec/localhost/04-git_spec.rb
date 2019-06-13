require 'spec_helper'

describe package('git'), :if => os[:family] == 'ubuntu' do
  it { should be_installed }
end

## Check if git command exits with a successful exit code.
describe command('git --version'), :if => os[:family] == 'ubuntu' do
  its(:exit_status) { should eq 0 }
end