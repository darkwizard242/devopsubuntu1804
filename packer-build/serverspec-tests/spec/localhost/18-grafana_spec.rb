require 'spec_helper'


if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe file('/etc/apt/sources.list.d/grafana.list') do
      it { should exist }
      it { should be_file }
      it { should be_readable }
      it { should be_writable.by_user('root') }
      it { should be_mode 644 }
      its(:content) { should match /deb\ https\:\/\/packages\.grafana\.com\/oss\/deb\ stable\ main/ }
    end
  end
end


if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe service('grafana-server') do
      it { should be_enabled }
      it { should be_running.under('systemd') }
    end
  end
end

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe port(3000) do
      it { should be_listening }
    end
  end
end

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe user('grafana') do
      it { should exist }
      it { should have_login_shell '/bin/false' }
      it { should belong_to_primary_group 'grafana' }
    end
  end
end

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe file('/usr/sbin/grafana-server') do
      it { should be_file }
      it { should be_owned_by 'root' }
    end
  end
end

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe file('/etc/grafana') do
      it { should be_directory }
      it { should be_owned_by 'root' }
    end
  end
end

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe file('/var/lib/grafana') do
      it { should be_directory }
      it { should be_owned_by 'grafana' }
    end
  end
end

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe file('/var/log/grafana') do
      it { should be_directory }
      it { should be_owned_by 'grafana' }
    end
  end
end

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe file('/etc/grafana/grafana.ini') do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should contain 'data = /var/lib/grafana' }
      it { should contain 'logs = /var/log/grafana' }
      it { should contain 'provisioning = /etc/grafana/provisioning' }
    end
  end
end
