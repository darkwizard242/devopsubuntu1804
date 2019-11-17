require 'spec_helper'


if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe file('/etc/apt/sources.list.d/google-cloud-sdk.list') do
      it { should exist }
      it { should be_file }
      it { should be_readable }
      it { should be_writable.by_user('root') }
      it { should be_mode 644 }
      its(:content) { should match /deb\ http\:\/\/packages\.cloud\.google\.com\/apt\ cloud\-sdk\-bionic\ main/ }
    end
    describe package('google-cloud-sdk') do
      it { should be_installed }
    end
    describe file('/usr/bin/gcloud') do
      it { should exist }
      it { should be_symlink }
      it { should be_executable }
    end
    describe command('gcloud --version') do
      its(:exit_status) { should eq 0 }
    end
    describe command('which gcloud') do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should match /\/usr\/bin\/gcloud/ }
    end
  end
end
