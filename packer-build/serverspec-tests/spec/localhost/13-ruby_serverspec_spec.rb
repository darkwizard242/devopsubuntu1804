require 'spec_helper'

describe package('ruby') do
  it { should be_installed }
end

describe command('ruby --version') do
  its(:exit_status) { should eq 0 }
end

describe package('serverspec') do
  it { should be_installed.by('gem') }
end
