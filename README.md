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

Disable iptables

## Module Description

This module is intended to **disable iptables** by setting an empty rule set (IPv4 only)

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
  * SLES 11 SP 3
    * does not manage any files

### Setup Requirements

This module requires pluginsync enabled

### Beginning with iptables

```puppet
class { 'iptables': }
```

## Usage

Put the classes, types, and resources for customizing, configuring, and doing
the fancy stuff with your module here.

## Reference

### iptables

* **ensure**: (default: running)
* **enable**: (default: true)
* **manage_docker_service**: (default: false)
* **manage_service**: (default: true)
* **manage_logrotate**: add logrotate config file (default: true)
* **logrotate_rotate**     = '4',
* **logrotate_compress**   = true,
* **logrotate_missingok**  = true,
* **logrotate_notifempty** = true,
* **logrotate_frequency**  = 'weekly',

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
