require 'spec_helper'

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe command('aws --version') do
      its(:exit_status) { should eq 0 }
    end
  end
end
