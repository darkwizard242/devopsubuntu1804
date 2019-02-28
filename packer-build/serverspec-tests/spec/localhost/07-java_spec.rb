require 'spec_helper'


describe package('openjdk-8-jdk') do
  it { should be_installed }
end

describe command('java -version') do
  its(:exit_status) { should eq 0 }
end
