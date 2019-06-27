require 'spec_helper'

describe service('node_exporter'), :if => os[:family] == 'ubuntu' do
  it { should be_enabled }
  it { should be_running }
end

describe port(9100), :if => os[:family] == 'ubuntu' do
  it { should be_listening }
end

describe user('node_exporter') do
  it { should exist }
  it { should have_login_shell '/bin/false' }
  it { should belong_to_primary_group 'node_exporter' }
end

describe file('/usr/local/bin/node_exporter'), :if => os[:family] == 'ubuntu' do
  it { should be_file }
  it { should be_owned_by 'node_exporter' }
end