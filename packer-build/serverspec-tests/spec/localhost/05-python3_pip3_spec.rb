require 'spec_helper'

## Check for python3 package
if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe package('python3') do
      it { should be_installed }
    end
  end
end

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe command('python3 --version') do
      its(:exit_status) { should eq 0 }
    end
  end
end

## Check for python3-pip package
if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe package('python3-pip') do
      it { should be_installed }
    end
  end
end

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe command('pip3 --version') do
      its(:exit_status) { should eq 0 }
    end
  end
end
