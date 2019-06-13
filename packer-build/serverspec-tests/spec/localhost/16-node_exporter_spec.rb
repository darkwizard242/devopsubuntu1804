require 'spec_helper'

describe service('node_exporter'), :if => os[:family] == 'ubuntu' do
  it { should be_enabled }
  it { should be_running }
end

describe port(9100), :if => os[:family] == 'ubuntu' do
  it { should be_listening }
end

describe file('/usr/local/bin/node_exporter'), :if => os[:family] == 'ubuntu' do
  it { should be_file }
end
