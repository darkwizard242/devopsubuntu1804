require 'spec_helper'

## Check if terraform binary exists in /bin/
describe file('/bin/terraform') do
  it { should exist }
end

## Check if terraform is a file.
describe file('/bin/terraform') do
  it { should be_file }
end

## Check if terraform binary command exists with a successful exit code.
describe command('terraform --version') do
  its(:exit_status) { should eq 0 }
end
