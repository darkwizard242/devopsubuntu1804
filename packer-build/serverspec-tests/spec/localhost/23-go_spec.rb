require 'spec_helper'


if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe file('/usr/local/go') do
      it { should be_directory }
      it { should be_owned_by 'root' }
      it { should be_mode 755 }
    end
    describe file('/usr/local/go/bin/go') do
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
    describe file('/etc/profile.d/go.sh') do
      it { should exist }
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_readable.by_user('root') }
      it { should be_readable.by('group') }
      it { should be_writable.by_user('root') }
      it { should be_mode 644 }
      it { should contain 'export PATH=$PATH:/usr/local/go/bin' }
    end
    describe command('go version') do
      its(:exit_status) { should eq 0 }
    end
    describe command('which go') do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should match /\/usr\/local\/go\/bin\/go/ }
    end
  end
end
