require 'spec_helper'


describe file('/etc/apt/sources.list.d/google-cloud-sdk.list') do
  it { should be_file }
  it { should contain 'deb http://packages.cloud.google.com/apt cloud-sdk-bionic main' }
end

describe package('google-cloud-sdk') do
  it { should be_installed }
end

describe file('/usr/bin/gcloud') do
  it { should be_file }
end

describe command('gcloud --version') do
  its(:exit_status) { should eq 0 }
end
