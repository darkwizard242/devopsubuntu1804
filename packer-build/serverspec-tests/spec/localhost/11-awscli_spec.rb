require 'spec_helper'

describe command('aws --version'), :if => os[:family] == 'ubuntu' do
  its(:exit_status) { should eq 0 }
end
