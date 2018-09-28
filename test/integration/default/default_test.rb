# # encoding: utf-8

# Inspec test for recipe cesi::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

unless os.windows?
  describe group('cesi') do
    it { should exist }
  end

  describe user('cesi') do
    it { should exist }
    its('group') { should eq 'cesi' }
    its('home') { should eq '/opt/cesi' }
  end

  describe command('git') do
    it { should exist }
  end

  describe file('/opt/cesi') do
    it { should exist }
    its('type') { should eq :directory }
  end

  describe file('/opt/cesi/.git') do
    it { should exist }
    its('type') { should eq :directory }
  end

  describe file('/opt/cesi/cesi/run.py') do
    it { should exist }
    its('mode') { should cmp '0755' }
  end

  describe file('/opt/cesi/cesi.conf') do
    it { should exist }
  end

  describe command('pip3') do
    it { should exist }
  end

  describe command('python3') do
    it { should exist }
  end

  describe service('cesi') do
    it { should be_enabled }
    it { should be_running }
  end

  describe port(5000), :skip do
    it { should be_listening }
  end

  describe command('curl http://localhost:5000') do
    its(:stdout) { should match /Cesi/ }
  end

end
