class iptables  (
                  $ensure                = $iptables::params::service_ensure_default,
                  $enable                = $iptables::params::service_enable_default,
                  $manage_docker_service = false,
                  $manage_service        = true,
                  $manage_logrotate      = true,
                  $logrotate_rotate      = '4',
                  $logrotate_compress    = true,
                  $logrotate_missingok   = true,
                  $logrotate_notifempty  = true,
                  $logrotate_frequency   = 'weekly',
                ) inherits iptables::params {

  if(!defined(Class['::firewalld']))
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

  if($manage_logrotate)
  {
    logrotate::logs { 'iptables':
      ensure        => present,
      log           => [ '/var/log/iptables.log' ],
      rotate        => $logrotate_rotate,
      compress      => $logrotate_compress,
      missingok     => $logrotate_missingok,
      notifempty    => $logrotate_notifempty,
      frequency     => $logrotate_frequency,
    }
  }

}
