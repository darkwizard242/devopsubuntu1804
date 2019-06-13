require 'spec_helper'

## Check if terraform binary exists in /bin/ and it's permissions
describe file('/bin/terraform'), :if => os[:family] == 'ubuntu' do
  it { should exist }
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should be_readable.by_user('root') }
  it { should be_readable.by('group') }
  it { should be_executable.by_user('root') }
  it { should be_executable.by('group') }
end


## Check if terraform binary command exists with a successful exit code.
describe command('terraform --version'), :if => os[:family] == 'ubuntu' do
  its(:exit_status) { should eq 0 }
end
