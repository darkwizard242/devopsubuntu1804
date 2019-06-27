require 'spec_helper'

describe service('alertmanager'), :if => os[:family] == 'ubuntu' do
  it { should be_enabled }
  it { should be_running.under('systemd') }
end

describe port(9093), :if => os[:family] == 'ubuntu' do
  it { should be_listening }
end

describe user('alertmanager') do
  it { should exist }
  it { should have_login_shell '/bin/false' }
  it { should belong_to_primary_group 'alertmanager' }
end

describe file('/usr/local/bin/alertmanager'), :if => os[:family] == 'ubuntu' do
  it { should be_file }
  it { should be_owned_by 'alertmanager' }
end

describe file('/usr/local/bin/amtool'), :if => os[:family] == 'ubuntu' do
  it { should be_file }
  it { should be_owned_by 'alertmanager' }
end

describe file('/etc/alertmanager'), :if => os[:family] == 'ubuntu' do
  it { should be_directory }
  it { should be_owned_by 'alertmanager' }
end

describe file('/etc/alertmanager/alertmanager.yml'), :if => os[:family] == 'ubuntu' do
  it { should be_file }
  it { should be_owned_by 'alertmanager' }
end