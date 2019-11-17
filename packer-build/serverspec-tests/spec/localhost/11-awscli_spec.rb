require 'spec_helper'

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe file('/usr/local/bin/aws') do
      it { should exist }
      it { should be_file }
      it { should be_executable }
    end
    describe command('aws --version') do
      its(:exit_status) { should eq 0 }
    end
    describe command('which aws') do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should match /\/usr\/local\/bin\/aws/ }
    end
  end
end
