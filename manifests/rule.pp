# - Allow ssh connections
# - Allow HTTPS
# - Allow communication between the 3 VM with TCP and UDP protocols on the port range 9300 to 9400.
# - Allow communication with 192.168.188.142 with TCP protocol on port 9200), this 3 VM must communicate with the VIP elasticsearch-eupp (IP: 192.168.188.142 ).
define iptables::rule (
                        $description = $name,
                        $chain       = 'INPUT',
                        $target      = 'REJECT',
                        $protocol    = undef,
                        $dport       = undef,
                        $order       = '42',
                        $persistent  = true,
                        $ip_version  = '4',
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



  concat::fragment { "iptables (${persistent}) rule ${order} ${chain} ${protocol} ${dport} ${target}":
    target  => $target_file,
    order   => "01-${chain}-${order}",
    content => template("${module_name}/rule.erb"),
  }


}
