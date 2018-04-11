require 'spec_helper_acceptance'
require_relative './version.rb'

describe 'iptables class' do

  context 'basic setup' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOF

      class { 'iptables':
        manage_logrotate => false,
      }

      iptables::rule { 'Allow tcp/22':
        protocols => [ 'tcp' ],
        dport     => '22',
        target    => 'ACCEPT',
      }

      iptables::rule { 'Allow udp/53 and tcp/53':
        dport  => '53',
        target => 'ACCEPT',
      }

      iptables::rule { 'multiport test':
        dport_range => '9300:9400',
        target      => 'ACCEPT',
      }

      iptables::rule { 'dst test':
        destination_addr => '1.1.1.1',
        target           => 'ACCEPT',
      }

      iptables::rule { 'inverse dst test':
        source_addr         => '1.0.0.1',
        inverse_source_addr => true,
        target              => 'ACCEPT',
      }

      iptables::rule { 'reject not local tcp/23':
        protocols         => [ 'tcp' ],
        dport             => '23',
        target            => 'REJECT',
        interface         => 'lo',
        inverse_interface => true,
        target_options    => [ '--reject-with icmp-port-unreachable' ],
      }

      EOF

      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end

    describe service($servicename) do
      it { should be_enabled }
    end

  end
end
