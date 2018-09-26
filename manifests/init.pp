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

  $firewalld_status_var=getvar('::eyp_firewalld_status')
  if($firewalld_status_var==undef) or ($::eyp_firewalld_status!='0')
  {
    package { $iptables::params::iptables_pkgs:
      ensure => 'installed',
    }

    if($iptables::params::iptablesrulesetfile_ipv4!=undef)
    {
      concat { $iptables::params::iptablesrulesetfile_ipv4:
        ensure  => 'present',
        owner   => 'root',
        group   => 'root',
        mode    => '0600',
        notify  => Class['iptables::service'],
        require => Package[$iptables::params::iptables_pkgs],
        before  => Class['iptables::service'],
      }

      concat::fragment { "default ruleset ${iptables::params::iptablesrulesetfile_ipv4}":
        target  => $iptables::params::iptablesrulesetfile_ipv4,
        order   => '00',
        content => template("${module_name}/default_ruleset.erb"),
      }

      concat::fragment { "commit  ${iptables::params::iptablesrulesetfile_ipv4}":
        target  => $iptables::params::iptablesrulesetfile_ipv4,
        order   => '99',
        content => "COMMIT\n",
      }
    }

    if($iptables::params::iptablesrulesetfile_ipv6!=undef)
    {
      concat { $iptables::params::iptablesrulesetfile_ipv6:
        ensure  => 'present',
        owner   => 'root',
        group   => 'root',
        mode    => '0600',
        notify  => Class['iptables::service'],
        require => Package[$iptables::params::iptables_pkgs],
        before  => Class['iptables::service'],
      }

      concat::fragment { "default ruleset ${iptables::params::iptablesrulesetfile_ipv6}":
        target  => $iptables::params::iptablesrulesetfile_ipv6,
        order   => '00',
        content => template("${module_name}/default_ruleset.erb"),
      }

      concat::fragment { "commit  ${iptables::params::iptablesrulesetfile_ipv6}":
        target  => $iptables::params::iptablesrulesetfile_ipv6,
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
    if(defined(Class[::logrotate]))
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

  if($iptables::params::netfilter_script!=undef)
  {
    file { $iptables::params::netfilter_script:
      ensure  => 'present',
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      content => file("${module_name}/netfilter-persistent.sh"),
      require => Package[$iptables::params::iptables_pkgs],
      before  => Class['iptables::service'],
      notify  => Class['iptables::service'],
    }

    systemd::service { $iptables::params::iptables_servicename:
      description       => 'netfilter persistent configuration',
      before_units      => [ 'network.target' ],
      wants             => [ 'systemd-modules-load.service', 'local-fs.target' ],
      after_units       => [ 'systemd-modules-load.service', 'local-fs.target' ],
      type              => 'oneshot',
      remain_after_exit => true,
      execstart         => "${iptables::params::netfilter_script} start",
      execstop          => "${iptables::params::netfilter_script} stop",
      require           => File[$iptables::params::netfilter_script],
      before            => Class['iptables::service'],
      notify            => Class['iptables::service'],
    }
  }
}
