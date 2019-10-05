require 'spec_helper'

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe service('alertmanager') do
      it { should be_enabled }
      it { should be_running.under('systemd') }
    end
  end
end

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe port(9093) do
      it { should be_listening }
    end
  end
end

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe user('alertmanager') do
      it { should exist }
      it { should have_login_shell '/bin/false' }
      it { should belong_to_primary_group 'alertmanager' }
    end
  end
end

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe file('/usr/local/bin/alertmanager') do
      it { should be_file }
      it { should be_owned_by 'alertmanager' }
    end
  end
end

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe file('/usr/local/bin/amtool') do
      it { should be_file }
      it { should be_owned_by 'alertmanager' }
    end
  end
end

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe file('/etc/alertmanager') do
      it { should be_directory }
      it { should be_owned_by 'alertmanager' }
    end
  end
end

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe file('/etc/alertmanager/alertmanager.yml') do
      it { should be_file }
      it { should be_owned_by 'alertmanager' }
    end
  end
end
