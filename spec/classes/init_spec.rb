require 'spec_helper'
describe 'iptables' do

  context 'CentOS 5' do

    let :facts do
    {
      :osfamily => 'RedHat',
      :operatingsystem => 'CentOS',
      :operatingsystemrelease => '5.3',
    }
    end

    it { should contain_class('iptables') }
  end

  context 'CentOS 6' do

    let :facts do
    {
      :osfamily => 'RedHat',
      :operatingsystem => 'CentOS',
      :operatingsystemrelease => '6.3',
    }
    end

    it { should contain_class('iptables') }
  end

  context 'CentOS 7' do

    let :facts do
    {
      :osfamily => 'RedHat',
      :operatingsystem => 'CentOS',
      :operatingsystemrelease => '7.3',
    }
    end

    it { should contain_class('iptables') }
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

  context 'unsupported OS' do
    let :facts do
    {
      :osfamily => 'Debian',
      :operatingsystem => 'Ubuntu',
      :operatingsystemrelease => '14.0',
    }
    end

    it {
      expect { should raise_error(Puppet::Error) }
    }
  end

end
