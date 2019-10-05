require 'spec_helper'

## Check if jenkins package is installed.
if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe package('jenkins') do
      it { should be_installed }
    end
  end
end

## Check if jenkins service is enabled and running.
if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe service('jenkins') do
      it { should be_enabled }
      it { should be_running }
    end
  end
end

## Check if listening on port 8080.
if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe port(8080) do
      it { should be_listening }
    end
  end
end

## Check if the jenkins directory exists and it's ownership.
if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe file('/var/lib/jenkins') do
      it { should be_directory }
      it { should be_owned_by 'jenkins' }
    end
  end
end
