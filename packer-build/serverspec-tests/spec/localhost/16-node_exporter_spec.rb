require 'spec_helper'

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe service('node_exporter') do
      it { should be_enabled }
      it { should be_running }
    end
    describe port(9100) do
      it { should be_listening }
    end
    describe file('/usr/local/bin/node_exporter') do
      it { should exist }
      it { should be_file }
      it { should be_owned_by 'node_exporter' }
      it { should be_executable }
    end
    describe command('which node_exporter') do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should match /\/usr\/local\/bin\/node_exporter/ }
    end
    describe user('node_exporter') do
      it { should exist }
      it { should have_login_shell '/bin/false' }
      it { should belong_to_primary_group 'node_exporter' }
    end
    describe file('/etc/systemd/system/node_exporter.service') do
      it { should exist }
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_mode 644 }
      its(:content) { should match /\/usr\/local\/bin\/node_exporter/ }
    end
  end
end
