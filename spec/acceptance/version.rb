
_osfamily               = fact('osfamily')
_operatingsystem        = fact('operatingsystem')
_operatingsystemrelease = fact('operatingsystemrelease').to_f

case _osfamily
when 'RedHat'
  $servicename = 'iptables'
  $ruleset = '/etc/sysconfig/iptables'
when 'Debian'
  $ruleset = '/etc/iptables/rules.v4'
  case _operatingsystemrelease
  when /^16.*$/
    $servicename = 'netfilter-persistent'
  else
    $servicename = 'iptables-persistent'
  end
else
  $ruleset = '-_-'
  $servicename = '-_-'
end
