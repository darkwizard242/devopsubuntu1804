require 'spec_helper'

describe service('grafana'), :if => os[:family] == 'ubuntu' do
  it { should be_enabled }
  it { should be_running.under('systemd') }
end

describe port(3000), :if => os[:family] == 'ubuntu' do
  it { should be_listening }
end

describe file('/usr/local/bin/grafana-server'), :if => os[:family] == 'ubuntu' do
  it { should be_file }
end
