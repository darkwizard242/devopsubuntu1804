require 'spec_helper'

## Validate  groups.
if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe group('vagrant') do
      it { should exist }
    end
  end
end

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe group('docker') do
      it { should exist }
    end
  end
end

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe group('jenkins') do
      it { should exist }
    end
  end
end

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe group('ansible') do
      it { should exist }
    end
  end
end


## Validate users.
if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe user('vagrant') do
      it { should exist }
      it { should belong_to_group 'sudo' }
      it { should belong_to_primary_group 'vagrant' }
      it { should have_home_directory '/home/vagrant' }
      it { should have_login_shell '/bin/bash' }
    end
  end
end

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe user('docker') do
      it { should exist }
      it { should belong_to_primary_group 'docker' }
      it { should belong_to_group 'docker' }
      it { should belong_to_group 'sudo' }
      it { should have_home_directory '/home/docker' }
      it { should have_login_shell '/bin/bash' }
    end
  end
end

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe user('ansible') do
      it { should exist }
      it { should belong_to_primary_group 'ansible' }
      it { should belong_to_group 'docker' }
      it { should belong_to_group 'sudo' }
      it { should have_home_directory '/home/ansible' }
      it { should have_login_shell '/bin/bash' }
    end
  end
end
