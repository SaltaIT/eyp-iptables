class iptables  (
                  $ensure                = $iptables::params::service_ensure_default,
                  $enable                = $iptables::params::service_enable_default,
                  $manage_docker_service = false,
                  $manage_service        = true,
                ) inherits iptables::params {

  if(!defined(Class['firewalld']))
  {
    package { $iptables::params::iptables_pkgs:
      ensure => 'installed',
    }

    if($iptables::params::iptablesrulesetfile!=undef)
    {
      file { $iptables::params::iptablesrulesetfile:
        ensure  => 'present',
        owner   => 'root',
        group   => 'root',
        mode    => '0600',
        content => template("${module_name}/sysconfig.erb"),
        notify  => Class['iptables::service'],
        require => Package[$iptables::params::iptables_pkgs],
        before  => Class['iptables::service'],
      }
    }

    class { 'iptables::service':
      ensure                => $ensure,
      enable                => $enable,
      manage_docker_service => $manage_docker_service,
      manage_service        => $manage_service,
      require               => Package[$iptables::params::iptables_pkgs],
    }
  }
}
