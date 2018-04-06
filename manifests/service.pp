class iptables::service (
                          $ensure                = $iptables::params::service_ensure_default,
                          $enable                = $iptables::params::service_enable_default,
                          $manage_docker_service = false,
                          $manage_service        = true,
                        ) inherits iptables::params {
  if(!defined(Class['firewalld']))
  {
    validate_bool($manage_docker_service)
    validate_bool($manage_service)
    validate_bool($enable)

    validate_re($ensure, [ '^running$', '^stopped$' ], "Not a valid daemon status: ${ensure}")

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
