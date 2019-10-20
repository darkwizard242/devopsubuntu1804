require 'spec_helper'


## Check if jenkins package is installed.
if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe file('/etc/apt/sources.list.d/jenkins.list') do
      it { should exist }
      it { should be_file }
      it { should be_readable }
      it { should be_writable.by_user('root') }
      it { should be_mode 644 }
      its(:content) { should match /deb\ http\:\/\/pkg\.jenkins\.io\/debian\-stable\ binary\// }
    end
    describe package('jenkins') do
      it { should be_installed }
    end
    describe service('jenkins') do
      it { should be_enabled }
      it { should be_running }
    end
    describe port(8080) do
      it { should be_listening }
    end
    describe file('/var/lib/jenkins') do
      it { should be_directory }
      it { should be_owned_by 'jenkins' }
    end
  end
end
