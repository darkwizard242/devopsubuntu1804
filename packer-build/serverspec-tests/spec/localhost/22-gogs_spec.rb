require 'spec_helper'

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe service('gogs') do
      it { should be_enabled }
      it { should be_running.under('systemd') }
    end
  end
end

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe port(3005) do
      it { should be_listening }
    end
  end
end

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe user('gogs') do
      it { should exist }
      it { should have_login_shell '/bin/false' }
      it { should belong_to_primary_group 'gogs' }
    end
  end
end

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe file('/opt/gogs/gogs') do
      it { should be_file }
      it { should be_owned_by 'gogs' }
      it { should be_mode 755 }
    end
  end
end

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe file('/opt/gogs/custom') do
      it { should be_directory }
      it { should be_owned_by 'gogs' }
      it { should be_mode 755 }
    end
  end
end

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe file('/opt/gogs/data') do
      it { should be_directory }
      it { should be_owned_by 'gogs' }
    end
  end
end

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe file('/opt/gogs/log') do
      it { should be_directory }
      it { should be_owned_by 'gogs' }
    end
  end
end

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe file('/opt/gogs/repositories') do
      it { should be_directory }
      it { should be_owned_by 'gogs' }
    end
  end
end

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe file('/opt/gogs/custom/conf/app.ini') do
      it { should be_file }
      it { should be_owned_by 'gogs' }
      it { should contain 'RUN_USER = gogs' }
      it { should contain 'ROOT = /opt/gogs/repositories' }
      it { should contain 'NAME     = gogs' }
      it { should contain 'PATH     = data/gogs.db' }
      it { should contain 'ROOT_PATH = /opt/gogs/log' }
    end
  end
end
