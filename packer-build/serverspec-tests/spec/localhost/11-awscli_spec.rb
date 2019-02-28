require 'spec_helper'

describe command('aws --version') do
  its(:exit_status) { should eq 0 }
end
