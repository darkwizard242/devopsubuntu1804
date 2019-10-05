require 'spec_helper'

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe service('prometheus') do
      it { should be_enabled }
      it { should be_running.under('systemd') }
    end
  end
end

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe port(9090) do
      it { should be_listening }
    end
  end
end

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe user('prometheus') do
      it { should exist }
      it { should have_login_shell '/bin/false' }
      it { should belong_to_primary_group 'prometheus' }
    end
  end
end

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe file('/usr/local/bin/prometheus') do
      it { should be_file }
      it { should be_owned_by 'prometheus' }
    end
  end
end

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe file('/usr/local/bin/promtool') do
      it { should be_file }
      it { should be_owned_by 'prometheus' }
    end
  end
end

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe file('/etc/prometheus') do
      it { should be_directory }
      it { should be_owned_by 'prometheus' }
    end
  end
end

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe file('/etc/prometheus/console_libraries') do
      it { should be_directory }
      it { should be_owned_by 'prometheus' }
    end
  end
end

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe file('/etc/prometheus/consoles') do
      it { should be_directory }
      it { should be_owned_by 'prometheus' }
    end
  end
end

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe file('/var/lib/prometheus') do
      it { should be_directory }
      it { should be_owned_by 'prometheus' }
    end
  end
end

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe file('/etc/prometheus/prometheus.yml') do
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
  end
end
