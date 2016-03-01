class iptables  (
                  $ensure ='running',
                  $enable=true
                ) inherits iptables::params {

  package { $iptables::params::iptables_pkgs:
    ensure => 'installed',
  }

  file { '/etc/sysconfig/iptables':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template("${module_name}/sysconfig.erb"),
    notify  => Class['iptables::service'],
  }

  class { 'iptables::service':
    ensure => $ensure,
    enable => $enable,
  }

}
