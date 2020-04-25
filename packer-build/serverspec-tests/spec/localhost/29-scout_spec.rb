require 'spec_helper'

## Check if scout binary exists in /usr/local/bin and it's permissions
if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe file('/usr/local/bin/scout') do
      it { should exist }
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_readable.by_user('root') }
      it { should be_readable.by('group') }
      it { should be_executable.by_user('root') }
      it { should be_executable.by('group') }
      it { should be_writable.by_user('root') }
      it { should be_mode 755 }
    end
  end
end


if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe command('scout help') do
      its(:exit_status) { should eq 0 }
    end
  end
end


if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe command('which scout') do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should match /\/usr\/local\/bin\/scout/ }
    end
  end
end
