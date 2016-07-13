# iptables

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with iptables](#setup)
    * [What iptables affects](#what-iptables-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with iptables](#beginning-with-iptables)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

Disable iptables

## Module Description

This module is intended to **disable iptables** by setting an empty rule set (IPv4 only)

## Setup

### What iptables affects

Manages:
* package
* service
* files:
  * RedHat:
    * /etc/sysconfig/iptables
  * Debian:
    * /etc/iptables/rules.v4

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

## Limitations

Tested on:
* CentOS 5
* CentOS 6
* CentOS 7
* Ubuntu 14.04


## Development

We are pushing to have acceptance testing in place, so any new feature must
have tests to check both presence and absence of any feature

### Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
