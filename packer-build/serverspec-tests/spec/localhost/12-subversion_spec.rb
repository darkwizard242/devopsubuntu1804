require 'spec_helper'

describe package('subversion') do
  it { should be_installed }
end

describe command('svn --version') do
  its(:exit_status) { should eq 0 }
end
