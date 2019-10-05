require 'spec_helper'

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe service('grafana') do
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
    describe file('/opt/grafana/bin/grafana-server') do
      it { should be_file }
      it { should be_owned_by 'grafana' }
    end
  end
end

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe file('/opt/grafana') do
      it { should be_directory }
      it { should be_owned_by 'grafana' }
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
    describe file('/opt/grafana/conf/grafana.ini') do
      it { should be_file }
      it { should be_owned_by 'grafana' }
      it { should contain 'data = /var/lib/grafana' }
      it { should contain 'logs = /var/log/grafana' }
      it { should contain 'plugins = /opt/grafana/plugins' }
      it { should contain 'provisioning = /opt/grafana/conf/provisioning' }
    end
  end
end
