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
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Sebastian Hetze <shetze@lunetix.org>
#
# === Copyright
#
# Copyright 2015 Sebastian Hetze
#
class dockerhost (
  $listen_address = '0.0.0.0',
  $listen_port = '2375',
  $registries = [ 'registry.access.redhat.com', ],

){

class { 'docker':
  bind_to => "tcp://$listen_address:$listen_port",
  add_registry => $registries,
}

package { 'firewalld':
  ensure => 'installed',
}

exec { "firewalld_prepare_docker":
    require => [ Package["firewalld"], ],
    command => "firewall-cmd --permanent --add-port=$listen_port/tcp &&
                firewall-cmd  --complete-reload",
    unless => "firewall-cmd --list-all|grep -q $listen_port",
    path => "/usr/bin/",
}

}
