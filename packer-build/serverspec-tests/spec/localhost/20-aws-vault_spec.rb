require 'spec_helper'

## Check if aws-vault binary exists in /usr/local/bin and it's permissions
if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe file('/usr/local/bin/aws-vault') do
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
    describe command('aws-vault --version') do
      its(:exit_status) { should eq 0 }
    end
  end
end


if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe command('which aws-vault') do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should match /\/usr\/local\/bin\/aws-vault/ }
    end
  end
end


if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe file('/home/vagrant/.bashrc') do
      it { should exist }
      it { should be_file }
      it { should be_readable }
      it { should be_writable.by_user('vagrant') }
      it { should be_mode 644 }
      its(:content) { should match /export\ AWS\_VAULT\_BACKEND\=\"file\"/ }
    end
  end
end
