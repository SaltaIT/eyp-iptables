class iptables  (
                  $ensure ='running',
                  $enable=true
                ) inherits params {

  file { '/etc/sysconfig/iptables':
    ensure => 'present',
    owner => 'root',
    group => 'root',
    mode => '0600',
    content => template("iptables/sysconfig.erb"),
    notify => Service['iptables'],
  }

  service { 'iptables':
    ensure => $ensure,
    enable => $enable,
  }

}
