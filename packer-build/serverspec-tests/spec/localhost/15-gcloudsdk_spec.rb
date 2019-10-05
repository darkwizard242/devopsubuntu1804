require 'spec_helper'


if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe file('/etc/apt/sources.list.d/google-cloud-sdk.list') do
      it { should be_file }
      it { should contain 'deb http://packages.cloud.google.com/apt cloud-sdk-bionic main' }
    end
  end
end

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe package('google-cloud-sdk') do
      it { should be_installed }
    end
  end
end

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe file('/usr/bin/gcloud') do
      it { should be_file }
    end
  end
end

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe command('gcloud --version') do
      its(:exit_status) { should eq 0 }
    end
  end
end
