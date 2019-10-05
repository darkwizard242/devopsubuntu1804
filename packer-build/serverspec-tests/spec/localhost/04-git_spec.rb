require 'spec_helper'

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe package('git') do
      it { should be_installed }
    end
  end
end

## Check if git command exits with a successful exit code.
if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe command('git --version') do
      its(:exit_status) { should eq 0 }
    end
  end
end
