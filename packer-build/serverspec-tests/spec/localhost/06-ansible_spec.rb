require 'spec_helper'

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe ppa('ansible/ansible') do
      it { should exist }
      it { should be_enabled }
    end
  end
end

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe package('ansible') do
      it { should be_installed }
    end
  end
end

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe command('ansible --version') do
      its(:exit_status) { should eq 0 }
    end
  end
end
