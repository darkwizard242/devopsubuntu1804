require 'spec_helper'

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe package('subversion') do
      it { should be_installed }
    end
  end
end

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe command('svn --version') do
      its(:exit_status) { should eq 0 }
    end
  end
end
