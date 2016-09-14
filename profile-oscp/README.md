# oscp

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with oscp](#setup)
    * [What oscp affects](#what-oscp-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with oscp](#beginning-with-oscp)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

This profile implements an OpenShift Container Platform (OSCP) host (node or master)
ready to perfom the actual OpenShift installation using the advanced ansible method.

An ansible inventory is prepared by the oscp profile to setup a four host cluster (1
master, 1 infra, 2 worker nodes), ready to start with a reasonable demo, test
or PoC use case.

It is intended to be used with RHEL-7 and Satellite-6.

## Module Description

oscp is designed as a profile class. It is used to instanciate a LunetIX/docker module and prepare a system to become a member of a OpenShift cluster.

The oscp profile creates a docker server with appropriate settings to host a OpenShift node (or master).
It then installs the required RPMs for OpenShift and creates the ansible inventory file to roll out a 4 node OSCP cluster.

You can use this profile as quickstart for a OpenShift demo, test or PoC setup.
Or you may use it as an example how puppet and ansible cooperate and benefit
from each other in the Satellite managed infrastructure.  First Satellite with
puppet makes sure the individual RHEL system is provisioned with well defined
content, integrated into your network and authentication system.  Then ansible
takes care of orchestrating the complex application, involving multiple
Satellite managed hosts and possibly other systems and active components.

## Setup

### What oscp affects

* All remaining space in the existing volume group will be allocated as
  docker-pool and the docker-storage-setup is executed.
* The OpenStack internal registry is added as insecure resource.

### Setup Requirements

The oscp profile expects a custom partitioning with a LV that has sufficient
free space to serve as a docker storage pool.  The next section shows an
example how such a partitioning can be created automatically with Satellite-6.

### Beginning with oscp

To start with the oscp profile, you should have a Satellite-6 server up and
running.  This requires appropriate Red Hat subscriptions for Satellite and
OpenStack Container Platform, which you may request for evaluation purposes
from your sales representative.  You can as well use Foreman/Katello and
OpenShift Origin.  You may use the Satellite-6 demo setup script to automate
the initial setup of Satellite-6.

You need to sync this puppet module and all its dependencies into the
Satellite. The LunetIX-git module may also be helpful.

The following lines are taken from the above mentionend Satellite setup script
and summarize some essential steps to prepare Satellite for the the
provisioning of an OpenStack host.  This excerpt omit creation of content view,
hostgroup, activation key and many more useful details you find in above
mentioned hammer script.

```bash
    ORG='Default Organization'
    LOC='Default Location'
    hammer repository-set enable --organization "$ORG" --product 'Red Hat Enterprise Linux Server' --basearch='x86_64' --releasever='7Server' --name 'Red Hat Enterprise Linux 7 Server (RPMs)'    
    time hammer repository synchronize --organization "$ORG" --product 'Red Hat Enterprise Linux Server'  --name  'Red Hat Enterprise Linux 7 Server RPMs x86_64 7Server' 2>/dev/null
    hammer repository-set enable --organization "$ORG" --product 'Red Hat OpenStack' --basearch='x86_64' --releasever='7Server' --name 'Red Hat OpenStack Platform 8 for RHEL 7 (RPMs)'
    time hammer repository synchronize --organization "$ORG" --product 'Red Hat OpenStack'  --name  'Red Hat OpenStack Platform 8 for RHEL 7 RPMs x86_64 7Server' 2>/dev/null

    cat >kickstart-docker <<EOF
<%#
kind: ptable
name: Kickstart Docker
oses:
- CentOS 5
- CentOS 6
- CentOS 7
- Fedora 16
- Fedora 17
- Fedora 18
- Fedora 19
- Fedora 20
- RedHat 5
- RedHat 6
- RedHat 7
%>
zerombr
clearpart --all --initlabel

part  /boot     --asprimary  --size=1024
part  swap                             --size=1024
part  pv.01     --asprimary  --size=12000 --grow

volgroup dockerhost pv.01
logvol / --vgname=dockerhost --size=9000 --name=rootvol
EOF
    hammer partition-table create  --file=kickstart-docker --name='Kickstart Docker' --os-family='Redhat' --organizations="$ORG" --locations="$LOC"

```

Once you have the Satellite prepared, you simply assign the hostgroup with the
oscp profile to a set of four new hosts that build a OpenShift cluster.  You
may want to name them master, infra, node01 and node02 for convenience.

Once all four hosts are provisioned, you can log into the master and start the
OpenShift cluster configuration using the prepared inventory file
/etc/ansible/hosts as described in http::

## Usage

The module includes a single class:

```puppet
include 'oscp'
```

You may add additional docker secure registries alongside the default Red Hat portal. For OpenShift however, you must keep the Red Hat registry in the list.

```puppet
class { 'oscp':
  registries => [ 'registry.access.redhat.com', 'registry.example.com' ],
}
```

You may change the network range for OpenStack internal registries which defaults to 172.30.0.0/16. You can add additional insecure registries by extending the array.

```puppet
class { 'oscp':
  insecure_registries => [ '172.29.0.0/16', ],
}
```

From within Satellite you can modify these parameters using the Smart Class Parameter feature.

## Reference

The oscp profile instanciates a LunetIX/docker class with devicemapper storage driver and auto_storage_setup set to true.

## Limitations

This module is tested only with RHEL-7, OpenStack-3.2  and Satellite-6.2

## Development

If you want to add/change something or provide feedback, feel free to contact me Sebastian Hetze <shetze@redhat.com>.
Or simply clone the module in github and create a pull request.

