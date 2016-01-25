class iptables  (
                  $ensure ='running',
                  $enable=true
                ) inherits params {

  package { $iptables::params::iptables_pkgs:
    ensure => 'installed',
  }

  file { '/etc/sysconfig/iptables':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template("${module_name}/sysconfig.erb"),
    notify  => Service['iptables'],
  }

  service { 'iptables':
    ensure  => $ensure,
    enable  => $enable,
    require => Package[$iptables::params::iptables_pkgs],
  }

}
