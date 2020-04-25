require 'spec_helper'


if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe file('/etc/apt/sources.list.d/trivy.list') do
      it { should exist }
      it { should be_file }
      it { should be_readable }
      it { should be_writable.by_user('root') }
      it { should be_mode 644 }
      its(:content) { should match /deb\ https\:\/\/aquasecurity\.github\.io\/trivy\-repo\/deb\ bionic\ main/ }
    end
  end
end


if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe package('trivy') do
      it { should be_installed }
    end
  end
end


if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe file('/usr/local/bin/trivy') do
      it { should exist }
      it { should be_file }
      it { should be_executable }
    end
  end
end


if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe command('trivy --version') do
      its(:exit_status) { should eq 0 }
    end
  end
end


if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe command('which trivy') do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should match /\/usr\/local\/bin\/trivy/ }
    end
  end
end
