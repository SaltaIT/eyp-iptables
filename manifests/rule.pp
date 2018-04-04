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
                      ) {
  include ::iptables

  if($iptables::params::iptablesrulesetfile==undef)
  {
    fail('currently unsupported')
  }

  if(!$persistent)
  {
    fail('currently unsupported')
  }


  concat::fragment { "iptables (${persistent}) rule ${order} ${chain} ${protocol} ${dport} ${target}":
    target  => $iptables::params::iptablesrulesetfile,
    order   => "01-${chain}-${order}",
    content => template("${module_name}/rule.erb"),
  }


}
