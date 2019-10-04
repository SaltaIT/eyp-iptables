class iptables::params
{
  case $::osfamily
  {
    'redhat' :
    {
      $netfilter_script = undef
      $iptables_servicename = 'iptables'

      $service_ensure_default = 'running'
      $service_enable_default = true
      case $::operatingsystemrelease
      {
        /^5.*$/:
        {
          $iptables_pkgs = [ 'iptables' ]
          $iptablesrulesetfile_ipv4 = '/etc/sysconfig/iptables'
          $iptablesrulesetfile_ipv6 = undef
        }
        /^6.*$/:
        {
          $iptables_pkgs = [ 'iptables' ]
          $iptablesrulesetfile_ipv4 = '/etc/sysconfig/iptables'
          $iptablesrulesetfile_ipv6 = undef
        }
        /^[78].*$/:
        {
          $iptables_pkgs = [ 'iptables', 'iptables-services' ]
          $iptablesrulesetfile_ipv4 = '/etc/sysconfig/iptables'
          $iptablesrulesetfile_ipv6 = '/etc/sysconfig/ip6tables'
        }
        default:
        {
          fail("Unsupported RHEL/CentOS version! - ${::operatingsystemrelease}")
        }
      }
    }
    'Debian':
    {
      $netfilter_script = undef
      $iptablesrulesetfile_ipv4 = '/etc/iptables/rules.v4'
      $iptablesrulesetfile_ipv6 = '/etc/iptables/rules.v6'

      $service_ensure_default = 'running'
      $service_enable_default = true
      case $::operatingsystem
      {
        'Ubuntu':
        {

          case $::operatingsystemrelease
          {
            /^14.*$/:
            {
              $iptables_pkgs = [ 'iptables', 'iptables-persistent' ]
              $iptables_servicename = 'iptables-persistent'
            }
            /^1[68].*$/:
            {
              $iptables_pkgs = [ 'iptables', 'iptables-persistent', 'netfilter-persistent' ]
              $iptables_servicename = 'netfilter-persistent'
            }
            default: { fail("Unsupported Ubuntu version! - ${::operatingsystemrelease}")  }
          }
        }
        'Debian':
        {
          case $::operatingsystemrelease
          {
            /^10\..*$/:
            {
              $iptables_pkgs = [ 'iptables', 'iptables-persistent', 'netfilter-persistent' ]
              $iptables_servicename = 'netfilter-persistent'
            }
            default: { fail("Unsupported Ubuntu version! - ${::operatingsystemrelease}")  }
          }
        }
        default: { fail('Unsupported Debian flavour!')  }
      }
    }
    'Suse':
    {
      $iptables_pkgs = [ 'iptables' ]
      case $::operatingsystem
      {
        'SLES':
        {
          case $::operatingsystemrelease
          {
            '11.3':
            {
              $netfilter_script = undef
              $iptablesrulesetfile_ipv4 = undef
              $iptablesrulesetfile_ipv6 = undef
              $iptables_servicename = 'SuSEfirewall2_setup'

              $service_ensure_default = 'stopped'
              $service_enable_default = false
            }
            /^12.[34]/:
            {
              $netfilter_script = '/usr/local/sbin/netfilter-persistent.sh'
              $iptablesrulesetfile_ipv4 = '/etc/sysconfig/iptables-rules.v4'
              $iptablesrulesetfile_ipv6 = '/etc/sysconfig/iptables-rules.v6'

              $iptables_servicename = 'netfilter-persistent'

              $service_ensure_default = 'running'
              $service_enable_default = true
            }
            default: { fail("Unsupported operating system ${::operatingsystem} ${::operatingsystemrelease}") }
          }
        }
        default: { fail("Unsupported operating system ${::operatingsystem}") }
      }
    }
    default:
    {
      fail('Unsupported OS!')
    }
  }
}
