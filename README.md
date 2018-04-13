# iptables

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What iptables affects](#what-iptables-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with iptables](#beginning-with-iptables)
4. [Usage](#usage)
5. [Reference](#reference)
5. [Limitations](#limitations)
6. [Development](#development)

## Overview

iptables management

## Module Description

This module is intended to manage IPv4 and IPv6 iptables rules

To be able to manage logrotate files it needs **eyp-logrotate** module installed. If you do not want to install **eyp-logrotate**, please set **iptables::manage_logrotate** to false

For **SLES11SP3** it just disables iptables, ruleset management is not supported

## Setup

### What iptables affects

Manages:
* package
* service (**SLES11SP3** disables **SuSEfirewall2**)
* files:
  * RedHat-like:
    * /etc/sysconfig/iptables
  * Debian-like:
    * /etc/iptables/rules.v4
    * /etc/iptables/rules.v6
  * SLES 11 SP 3
    * does not manage any file, intended just to disable iptables

### Setup Requirements

This module requires pluginsync enabled for puppet < 4

### Beginning with iptables

```puppet
class { 'iptables': }
```

## Usage

```puppet
class { 'iptables':
  manage_logrotate => false,
}

iptables::chain { 'DEMO':
  description => 'demo chain',
}

iptables::rule { 'fist process the demo chain':
  order => '01',
  target => 'DEMO',
}

iptables::rule { 'Allow udp/53 and tcp/53':
  dport  => '53',
  target => 'DEMO',
}

iptables::rule { 'Allow tcp/22':
  protocols => [ 'tcp' ],
  dport     => '22',
  target    => 'DEMO',
}

iptables::rule { 'count tcp/21':
  protocols => [ 'tcp' ],
  dport     => '21',
}

iptables::rule { 'Allow udp/53 and tcp/53':
  dport  => '53',
  target => 'DEMO',
}

iptables::rule { 'multiport test':
  dport_range => '9300:9400',
  target      => 'ACCEPT',
}

iptables::rule { 'dst test':
  destination_addr => '1.1.1.1',
  target           => 'ACCEPT',
}

iptables::rule { 'inverse dst test':
  source_addr         => '1.0.0.1',
  inverse_source_addr => true,
  target              => 'ACCEPT',
}

iptables::rule { 'reject not local tcp/23':
  protocols            => [ 'tcp' ],
  dport                => '23',
  target               => 'REJECT',
  in_interface         => 'lo',
  inverse_in_interface => true,
  reject_with          => icmp-port-unreachable,
}
```

created ruleset:

```
# puppet managed file
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
# multiport test
-A INPUT -p tcp --match multiport --dports 9300:9400 -j ACCEPT
-A INPUT -p udp --match multiport --dports 9300:9400 -j ACCEPT

# dst test
-A INPUT -p tcp -d 1.1.1.1 -j ACCEPT
-A INPUT -p udp -d 1.1.1.1 -j ACCEPT

# inverse dst test
-A INPUT -p tcp ! -s 1.0.0.1 -j ACCEPT
-A INPUT -p udp ! -s 1.0.0.1 -j ACCEPT

# Allow udp/53 and tcp/53
-A INPUT -p tcp --dport 53 -j ACCEPT
-A INPUT -p udp --dport 53 -j ACCEPT

# Allow tcp/22
-A INPUT -p tcp --dport 22 -j ACCEPT

# reject not local tcp/23
-A INPUT ! -i lo -p tcp --dport 23 -j REJECT --reject-with icmp-port-unreachable

COMMIT
```

## Reference

### iptables

* **ensure**: Service status (default: running)
* **enable**: Whether or not iptables service is enabled at boot (default: true)
* **manage_docker_service**: Whether o not to start iptables server inside a docker container (default: false)
* **manage_service**: Whether or not the service is managed (default: true)
* **manage_logrotate**: Add logrotate config file (default: true)
* **logrotate_frequency**: Rotation frequency (default: weekly)
* **logrotate_rotate**: How many rorations to keep (default: 4)
* **logrotate_compress**: Whether o not to compress logs once rotated (default: true)
* **logrotate_missingok**: Whether or not it is ok if the log file is missing (true)
* **logrotate_notifempty**: Whether or not to rotate an empty file (true)
* **default_input**:  default target for INPUT chain (default: ACCEPT)
* **default_forward**: default target for FORWARD chain (default: ACCEPT)
* **default_output**: default target for OUTPUT chain (default: ACCEPT)

### iptables::rule

* **target**: target for rule - Either **target** or **goto** must be defined (default: undef)
* **goto**: This  specifies  that the processing should continue in a user specified chain. Unlike the **target** option return will not continue processing in this chain but instead in the chain that called us via **target**- Either **target** or **goto** must be defined (default: undef)
* **description**: rule description (default: resource name)
* **chain**: chain to insert the rule to (default: INPUT)
* **protocols**: list of protocols (default: 'tcp', 'udp')
* **dport**: destination port (default: undef)
* **order**: rule order (default: 42)
* **ip_version**: IP version (default: 4)
* **dport_range**: destination port range (default: undef)
* **source_addr**: source address (default: undef)
* **inverse_source_addr**: use inverse match for source address (default: false)
* **destination_addr**: destination address (default: undef)
* **inverse_destination_addr**: use inverse match for destination address (default: false)
* **in_interface**: filter packets for incoming interface (default: undef)
* **inverse_in_interface**: use inverse match for in interface (default: false)
* **out_interface**: filter packets for outgoing interface (default: undef)
* **inverse_out_interface**: use inverse match for out interface (default: false)
* **states**: Array, stateful firewall states (default: [])
* **reject_with**: If target is set to REJECT, this option modifies REJECT behaviour to send a specific ICMP message back to the source host (default: undef)

## Limitations

Tested on:
* CentOS 5
* CentOS 6
* CentOS 7
* Ubuntu 14.04
* Ubuntu 16.04
* SLES 11 SP3

## Development

We are pushing to have acceptance testing in place, so any new feature must
have tests to check both presence and absence of any feature

### Contributing

1. Fork it using the development fork: [jordiprats/eyp-systemd](https://github.com/jordiprats/eyp-systemd)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
