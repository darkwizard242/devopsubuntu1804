require 'spec_helper'

## Validate .ssh folder for vagrant.
if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe file('/home/vagrant/.ssh') do
      it { should exist }
      it { should be_directory }
      it { should be_owned_by 'vagrant' }
      it { should be_mode 700 }
    end
  end
end
