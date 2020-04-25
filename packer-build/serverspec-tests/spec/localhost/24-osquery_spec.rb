require 'spec_helper'


if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe package('osquery') do
      it { should be_installed }
    end
  end
end


if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe service('osqueryd') do
      it { should be_enabled }
      it { should be_running.under('systemd') }
    end
  end
end


if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe file('/usr/bin/osqueryd') do
      it { should be_file }
      it { should be_owned_by 'root' }
    end
  end
end


if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe file('/usr/bin/osqueryi') do
      it { should be_symlink }
      it { should be_owned_by 'root' }
    end
  end
end


if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe file('/etc/osquery') do
      it { should be_directory }
      it { should be_owned_by 'root' }
    end
  end
end


if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe file('/usr/share/osquery') do
      it { should be_directory }
      it { should be_owned_by 'root' }
    end
  end
end


if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe file('/var/log/osquery') do
      it { should be_directory }
      it { should be_owned_by 'root' }
    end
  end
end


if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe file('/etc/osquery/osquery.conf') do
      it { should be_file }
      it { should be_owned_by 'root' }
    end
  end
end
