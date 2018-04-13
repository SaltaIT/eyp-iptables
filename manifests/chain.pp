define iptables::chain(
                        $chain_name  = $name,
                        $ip_version  = '4',
                        $description = undef,
                        $order       = '42',
                      ) {
  include ::iptables

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

  concat::fragment { "iptables ${ip_version} chain ${chain_name}":
    target  => $target_file,
    order   => "05-custom-chains-${order}",
    content => template("${module_name}/chain.erb"),
  }
}
