require 'spec_helper'

## Validate .ssh folder for vagrant.
describe file('/home/vagrant/.ssh'), :if => os[:family] == 'ubuntu' do
  it { should exist }
  it { should be_directory }
  it { should be_owned_by 'vagrant' }
  it { should be_mode 700 }
end

