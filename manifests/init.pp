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
                  $default_input         = 'ACCEPT',
                  $default_forward       = 'ACCEPT',
                  $default_output        = 'ACCEPT',
                ) inherits iptables::params {

  if(!defined(Class['::firewalld']))
  {
    package { $iptables::params::iptables_pkgs:
      ensure => 'installed',
    }

    if($iptables::params::iptablesrulesetfile!=undef)
    {
      concat { $iptables::params::iptablesrulesetfile:
        ensure  => 'present',
        owner   => 'root',
        group   => 'root',
        mode    => '0600',
        notify  => Class['iptables::service'],
        require => Package[$iptables::params::iptables_pkgs],
        before  => Class['iptables::service'],
      }

      concat::fragment { "globalconf header ${apache::params::baseconf}":
        target  => $iptables::params::iptablesrulesetfile,
        order   => '00',
        content => template("${module_name}/default_ruleset.erb"),
      }

      concat::fragment { "globalconf header ${apache::params::baseconf}":
        target  => $iptables::params::iptablesrulesetfile,
        order   => '99',
        content => "COMMIT\n",
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
    include ::logrotate

    logrotate::logs { 'iptables':
      ensure     => present,
      log        => [ '/var/log/iptables.log' ],
      rotate     => $logrotate_rotate,
      compress   => $logrotate_compress,
      missingok  => $logrotate_missingok,
      notifempty => $logrotate_notifempty,
      frequency  => $logrotate_frequency,
    }
  }

}
