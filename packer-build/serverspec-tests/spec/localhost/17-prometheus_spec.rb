require 'spec_helper'

describe service('prometheus'), :if => os[:family] == 'ubuntu' do
  it { should be_enabled }
  it { should be_running.under('systemd') }
end

describe port(9090), :if => os[:family] == 'ubuntu' do
  it { should be_listening }
end

describe file('/usr/local/bin/prometheus'), :if => os[:family] == 'ubuntu' do
  it { should be_file }
end

describe file('/opt/prometheus/prometheus.yml'), :if => os[:family] == 'ubuntu' do
  it { should be_file }
  it { should contain 'scrape_interval:     5s' }
  it { should contain 'evaluation_interval: 5s' }
  it { should contain 'node' }
  it { should contain 'localhost:9100' }
  it { should contain 'prometheus' }
  it { should contain 'localhost:9090' }
end
