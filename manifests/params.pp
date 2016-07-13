class iptables::params
{
  case $::osfamily
  {
    'redhat' :
    {
      $iptablesrulesetfile = '/etc/sysconfig/iptables'
      $iptables_servicename = 'iptables'
      case $::operatingsystemrelease
      {
        /^5.*$/ :
        {
          $iptables_pkgs = [ 'iptables' ]
        }
        /^6.*$/ :
        {
          $iptables_pkgs = [ 'iptables' ]
        }
        /^7.*$/ :
        {
          $iptables_pkgs = [ 'iptables', 'iptables-services' ]
        }
        default :
        {
          fail("Unsupported RHEL/CentOS version! - ${::operatingsystemrelease}")
        }
      }
    }
    'Debian':
    {
      $iptablesrulesetfile = '/etc/iptables/rules.v4'
      $iptables_servicename = 'iptables-persistent'
      case $::operatingsystem
      {
        'Ubuntu':
        {
          case $::operatingsystemrelease
          {
            /^14.*$/:
            {
              # per debian
              # http://systemadmin.es/2014/02/reglas-de-iptables-persistentes-en-debian-ubuntu
              $iptables_pkgs = [ 'iptables', 'iptables-persistent' ]
            }
            default: { fail("Unsupported Ubuntu version! - ${::operatingsystemrelease}")  }
          }
        }
        'Debian': { fail('Unsupported')  }
        default: { fail('Unsupported Debian flavour!')  }
      }
    }
    default  :
    {
      fail('Unsupported OS!')
    }
  }
}
