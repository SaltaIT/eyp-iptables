define iptables::rule (
                        $description              = $name,
                        $chain                    = 'INPUT',
                        $target                   = 'REJECT',
                        $target_options           = [],
                        $protocols                = [ 'tcp', 'udp' ],
                        $dport                    = undef,
                        $order                    = '42',
                        $persistent               = true,
                        $ip_version               = '4',
                        $dport_range              = undef,
                        $source_addr              = undef,
                        $inverse_source_addr      = false,
                        $destination_addr         = undef,
                        $interface                = undef,
                        $inverse_interface        = false,
                        $states                   = [],
                        $inverse_destination_addr = false,
                      ) {
  include ::iptables

  if(!$persistent)
  {
    fail('currently unsupported')
  }

  case $ip_version
  {
    '4':
    {
      if($iptables::params::iptablesrulesetfile_ipv4!=undef)
      {
        $target_file=$iptables::params::iptablesrulesetfile_ipv4
      }
      else
      {
        fail('currently unsupported')
      }
    }
    '6':
    {
      if($iptables::params::iptablesrulesetfile_ipv6!=undef)
      {
        $target_file=$iptables::params::iptablesrulesetfile_ipv6
      }
      else
      {
        fail('currently unsupported')
      }
    }
    default:
    {
      fail('not a supported IP protocol')
    }
  }

  concat::fragment { "iptables (${persistent}) rule ${order} ${chain} ${protocols} ${dport} ${target} ${inverse_source_addr} ${source_addr} ${inverse_destination_addr} ${destination_addr}":
    target  => $target_file,
    order   => "10-${chain}-${order}",
    content => template("${module_name}/rule.erb"),
  }

}
