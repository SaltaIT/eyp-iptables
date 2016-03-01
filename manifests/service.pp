class iptables::service (
                          $ensure ='running',
                          $enable=true
                        ) inherits iptables::params {

  if($::eyp_docker_iscontainer==undef or $::eyp_docker_iscontainer =~ /false/)
  {
    service { 'iptables':
      ensure  => $ensure,
      enable  => $enable,
      require => Package[$iptables::params::iptables_pkgs],
    }
  }
}
