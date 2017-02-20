require 'spec_helper'
describe 'iptables' do

  context 'CentOS 5' do

    let (:params) { { 'ensure' => 'running', 'enable' => true } }

    let :facts do
    {
      :osfamily => 'RedHat',
      :operatingsystem => 'CentOS',
      :operatingsystemrelease => '5.3',
    }
    end

    it { should contain_class('iptables') }

    it { should contain_package('iptables')}
    it { should_not contain_package('iptables-services')}

    it { should contain_service('iptables')}

    it { should contain_file('/etc/sysconfig/iptables').with({
      'ensure' => 'present',
      'owner'  => 'root',
      'group'  => 'root',
      'mode'   => '0600',
    })}
  end

  context 'CentOS 6' do

    let (:params) { { 'ensure' => 'running', 'enable' => true } }

    let :facts do
    {
      :osfamily => 'RedHat',
      :operatingsystem => 'CentOS',
      :operatingsystemrelease => '6.3',
    }
    end

    it { should contain_class('iptables') }

    it { should contain_package('iptables')}
    it { should_not contain_package('iptables-services')}

    it { should contain_service('iptables')}

    it { should contain_file('/etc/sysconfig/iptables').with({
      'ensure' => 'present',
      'owner'  => 'root',
      'group'  => 'root',
      'mode'   => '0600',
    })}
  end

  context 'CentOS 7' do

    let (:params) { { 'ensure' => 'running', 'enable' => true } }

    let :facts do
    {
      :osfamily => 'RedHat',
      :operatingsystem => 'CentOS',
      :operatingsystemrelease => '7.3',
    }
    end

    it { should contain_class('iptables') }

    it { should contain_package('iptables')}
    it { should contain_package('iptables-services')}

    it { should contain_service('iptables')}

    it { should contain_file('/etc/sysconfig/iptables').with({
      'ensure' => 'present',
      'owner'  => 'root',
      'group'  => 'root',
      'mode'   => '0600',
    })}
  end

  context 'unsupported OS' do
    let :facts do
    {
            :osfamily => 'SOFriki',
    }
    end

    it {
      expect { should raise_error(Puppet::Error) }
    }
  end

end
