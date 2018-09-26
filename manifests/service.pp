class iptables::service (
                          $ensure                = $iptables::params::service_ensure_default,
                          $enable                = $iptables::params::service_enable_default,
                          $manage_docker_service = false,
                          $manage_service        = true,
                        ) inherits iptables::params {

  $firewalld_status_var=getvar('::eyp_firewalld_status')
  if($firewalld_status_var==undef) or ($::eyp_firewalld_status!='0')
  {
    $is_docker_container_var=getvar('::eyp_docker_iscontainer')
    $is_docker_container=str2bool($is_docker_container_var)

    if( $is_docker_container==false or
        $manage_docker_service)
    {
      if($manage_service)
      {
        service { $iptables::params::iptables_servicename:
          ensure     => $ensure,
          enable     => $enable,
          hasrestart => true,
          require    => Package[$iptables::params::iptables_pkgs],
        }
      }
    }
  }
}
