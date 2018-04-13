define iptables::rule (
                        $description              = $name,
                        $order                    = '42',
                        $ip_version               = '4',
                        $chain                    = 'INPUT',
                        $target                   = undef,
                        $goto                     = undef,
                        $reject_with              = undef,
                        $protocols                = [ 'tcp', 'udp' ],
                        $dport                    = undef,
                        $dport_range              = undef,
                        $source_addr              = undef,
                        $inverse_source_addr      = false,
                        $destination_addr         = undef,
                        $inverse_destination_addr = false,
                        $in_interface              = undef,
                        $inverse_in_interface     = false,
                        $out_interface              = undef,
                        $inverse_out_interface     = false,
                        $states                   = [],
                      ) {
  include ::iptables

  if($target==undef and $goto==undef)
  {
    fail('Neither target nor goto is defined, please use one or the other')
  }

  if($target!=undef and $goto!=undef)
  {
    fail('target and goto cannot be both defined, please chose one')
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

  concat::fragment { "iptables rule IPv${ip_version} - ${order} ${chain} ${inverse_interface} ${interface} ${protocols} ${dport} ${target} ${inverse_source_addr} ${source_addr} ${inverse_destination_addr} ${destination_addr} ${states}":
    target  => $target_file,
    order   => "10-${chain}-${order}",
    content => template("${module_name}/rule.erb"),
  }

}
