require 'spec_helper'


if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe package('openjdk-8-jdk') do
    end
  end
end

if os[:family] == 'ubuntu'
  if os[:release] == '18.04'
    describe command('java -version') do
      its(:exit_status) { should eq 0 }
    end
  end
end
