require 'spec_helper'

## Check if terraform binary exists in /usr/local/bin and it's permissions
if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe file('/usr/local/bin/terraform') do
      it { should exist }
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_readable.by_user('root') }
      it { should be_readable.by('group') }
      it { should be_executable.by_user('root') }
      it { should be_executable.by('group') }
    end
  end
end


## Check if terraform binary command exists with a successful exit code.
if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe command('terraform --version') do
      its(:exit_status) { should eq 0 }
    end
  end
end
