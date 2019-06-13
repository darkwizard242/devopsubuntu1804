require 'spec_helper'

## Check if desired motd file exists.
describe file('/etc/update-motd.d/00-devops'), :if => os[:family] == 'ubuntu' do
  it { should exist }
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should be_writable.by_user('root') }
  it { should be_readable.by_user('root') }
  it { should be_readable.by('group') }
  it { should be_readable.by('others') }
  it { should be_executable.by_user('root') }
  it { should be_executable.by('group') }
  it { should be_executable.by('others') }
end

