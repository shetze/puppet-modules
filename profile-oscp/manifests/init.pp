# == Class: dockerhost
#
# Full description of class dockerhost here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { dockerhost:
#    listen_address => '192.168.1.15',
#  }
#
# === Authors
#
# Sebastian Hetze <shetze@lunetix.org>
#
# === Copyright
#
# Copyright 2016 Sebastian Hetze
#
class oscp (
  $listen_address = '0.0.0.0',
  $listen_port    = '2375',
  $registries     = [ 'registry.access.redhat.com', ],
  $insecure_registries     = [ '172.30.0.0/16', ],

){

class { 'docker':
  bind_to      => "tcp://$listen_address:$listen_port",
  add_registry => $registries,
  insecure_registry => $insecure_registries,
  storage_driver => 'devicemapper',
}

ensure_packages( ['firewalld', 'atomic-openshift-utils', 'wget', 'git', 'net-tools', 'bind-utils', 'iptables-services', 'bridge-utils', 'bash-completion', ] )

exec { "firewalld_prepare_docker":
    require => [ Package["firewalld"], ],
    command => "firewall-cmd --permanent --add-port=$listen_port/tcp --add-port 443/tcp --add-port 8443/tcp --add-port 22/tcp --add-port 9000/tcp --add-port 53/tcp --add-port 8053/tcp --add-port 80/tcp --add-port 1936/tcp --add-port 53/udp --add-port 8053/udp --add-port 4001/tcp --add-port 2379/tcp --add-port 2380/tcp --add-port 4789/udp --add-port 10250/tcp &&
                firewall-cmd  --complete-reload",
    unless  => "firewall-cmd --list-all|grep -q $listen_port",
    path    => "/usr/bin/",
}

}
