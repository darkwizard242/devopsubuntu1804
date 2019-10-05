require 'spec_helper'

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe service('node_exporter') do
      it { should be_enabled }
      it { should be_running }
    end
  end
end

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe port(9100) do
      it { should be_listening }
    end
  end
end

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe user('node_exporter') do
      it { should exist }
      it { should have_login_shell '/bin/false' }
      it { should belong_to_primary_group 'node_exporter' }
    end
  end
end

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe file('/usr/local/bin/node_exporter') do
      it { should be_file }
      it { should be_owned_by 'node_exporter' }
    end
  end
end
