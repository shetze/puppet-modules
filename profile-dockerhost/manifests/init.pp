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
# Copyright 2015 Sebastian Hetze
#
class dockerhost (
  $listen_address = '0.0.0.0',
  $listen_port    = '2375',
  $registries     = [ 'registry.access.redhat.com', ],

){

class { 'docker':
  bind_to      => "tcp://$listen_address:$listen_port",
  add_registry => $registries,
}

ensure_packages( ['firewalld',] )

file { '/root/Docker/jdk':
    ensure  => directory,
    mode    => '770',
}

file { '/root/Docker/eap':
    ensure  => directory,
    mode    => '770',
}

file { '/root/Docker/jdk/Dockerfile':
    ensure  => file,
    mode    => "644",
    content => template('dockerhost/Dockerfile-jdk.erb'),
    require =>  [ File["/root/Docker/jdk"] ],
}

file { '/root/Docker/eap/Dockerfile':
    ensure  => file,
    mode    => "644",
    content => template('dockerhost/Dockerfile-eap.erb'),
    require =>  [ File["/root/Docker/eap"] ],
}

file { '/root/Docker/eap/eapconfig.pp':
    ensure  => file,
    mode    => "644",
    content => template('dockerhost/eapconfig.erb'),
    require =>  [ File["/root/Docker/eap"] ],
}

exec { "firewalld_prepare_docker":
    require => [ Package["firewalld"], ],
    command => "firewall-cmd --permanent --add-port=$listen_port/tcp &&
                firewall-cmd  --complete-reload",
    unless  => "firewall-cmd --list-all|grep -q $listen_port",
    path    => "/usr/bin/",
}

}
