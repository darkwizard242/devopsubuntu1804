require 'spec_helper'

describe service('grafana'), :if => os[:family] == 'ubuntu' do
  it { should be_enabled }
  it { should be_running.under('systemd') }
end

describe port(3000), :if => os[:family] == 'ubuntu' do
  it { should be_listening }
end

describe user('grafana') do
  it { should exist }
  it { should have_login_shell '/bin/false' }
  it { should belong_to_primary_group 'grafana' }
end

describe file('/opt/grafana/bin/grafana-server'), :if => os[:family] == 'ubuntu' do
  it { should be_file }
  it { should be_owned_by 'grafana' }
end

describe file('/opt/grafana'), :if => os[:family] == 'ubuntu' do
  it { should be_directory }
  it { should be_owned_by 'grafana' }
end

describe file('/var/lib/grafana'), :if => os[:family] == 'ubuntu' do
  it { should be_directory }
  it { should be_owned_by 'grafana' }
end

describe file('/var/log/grafana'), :if => os[:family] == 'ubuntu' do
  it { should be_directory }
  it { should be_owned_by 'grafana' }
end

describe file('/opt/grafana/conf/grafana.ini'), :if => os[:family] == 'ubuntu' do
  it { should be_file }
  it { should be_owned_by 'grafana' }
  it { should contain 'data = /var/lib/grafana' }
  it { should contain 'logs = /var/log/grafana' }
  it { should contain 'plugins = /opt/grafana/plugins' }
  it { should contain 'provisioning = /opt/grafana/conf/provisioning' }
end