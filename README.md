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

iptables basic management

## Module Description

This module is intended to manage IPv4 and IPv6 iptables rules

To be able to manage logrotate files it needs **eyp-logrotate**

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

This module requires pluginsync enabled

### Beginning with iptables

```puppet
class { 'iptables': }
```

## Usage

```puppet
class { 'iptables':
  manage_logrotate => false,
}

iptables::rule { 'Allow tcp/22':
  protocols => [ 'tcp' ],
  dport => '22',
  target => 'ACCEPT',
}

iptables::rule { 'Allow udp/53 and tcp/53':
  dport => '53',
  target => 'ACCEPT',
}

iptables::rule { 'multiport test':
  dport_range => '9300:9400',
  target => 'ACCEPT',
}
```

ruleset created:

```
# puppet managed file
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
# multiport test
-A INPUT -p tcp --match multiport --dports 9300:9400 -j ACCEPT
-A INPUT -p udp --match multiport --dports 9300:9400 -j ACCEPT

# Allow tcp/22
-A INPUT -p tcp --dport 22 -j ACCEPT

# Allow udp/53 and tcp/53
-A INPUT -p tcp --dport 53 -j ACCEPT
-A INPUT -p udp --dport 53 -j ACCEPT

COMMIT
```

## Reference

### iptables

* **ensure**: (default: running)
* **enable**: (default: true)
* **manage_docker_service**: (default: false)
* **manage_service**: (default: true)
* **manage_logrotate**: add logrotate config file (default: true)
* **logrotate_rotate**: '4',
* **logrotate_compress**: true,
* **logrotate_missingok**: true,
* **logrotate_notifempty**: true,
* **logrotate_frequency**: 'weekly',
* **default_input**:  default target for INPUT chain (default: ACCEPT)
* **default_forward**: default target for FORWARD chain (default: ACCEPT)
* **default_output**: default target for OUTPUT chain (default: ACCEPT)

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

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
