require 'spec_helper'

describe service('prometheus'), :if => os[:family] == 'ubuntu' do
  it { should be_enabled }
  it { should be_running.under('systemd') }
end

describe port(9090), :if => os[:family] == 'ubuntu' do
  it { should be_listening }
end

describe user('prometheus') do
  it { should exist }
  it { should have_login_shell '/bin/false' }
  it { should belong_to_primary_group 'prometheus' }
end

describe file('/usr/local/bin/prometheus'), :if => os[:family] == 'ubuntu' do
  it { should be_file }
  it { should be_owned_by 'prometheus' }
end

describe file('/usr/local/bin/promtool'), :if => os[:family] == 'ubuntu' do
  it { should be_file }
  it { should be_owned_by 'prometheus' }
end

describe file('/etc/prometheus'), :if => os[:family] == 'ubuntu' do
  it { should be_directory }
  it { should be_owned_by 'prometheus' }
end

describe file('/etc/prometheus/console_libraries'), :if => os[:family] == 'ubuntu' do
  it { should be_directory }
  it { should be_owned_by 'prometheus' }
end

describe file('/etc/prometheus/consoles'), :if => os[:family] == 'ubuntu' do
  it { should be_directory }
  it { should be_owned_by 'prometheus' }
end

describe file('/var/lib/prometheus'), :if => os[:family] == 'ubuntu' do
  it { should be_directory }
  it { should be_owned_by 'prometheus' }
end

describe file('/etc/prometheus/prometheus.yml'), :if => os[:family] == 'ubuntu' do
  it { should be_file }
  it { should be_owned_by 'prometheus' }
  it { should contain 'scrape_interval:     5s' }
  it { should contain 'evaluation_interval: 5s' }
  it { should contain 'node' }
  it { should contain 'localhost:9100' }
  it { should contain 'prometheus' }
  it { should contain 'localhost:9090' }
  it { should contain 'alertmanager' }
  it { should contain 'localhost:9093' }
end