# == Class: appserver
#
# This is a simple puppet class showing how to deploy mostly static config files somewhat like with a Satellite-5 Config Channel
#
# === Parameters
#
# [*purpose*]
#   Sample parameter to describe the application pupose
#
# === Authors
#
# Sebastian Hetz <shetze@redhat.com>
#
# === Copyright
#
# Copyright 2016 Sebastian Hetze
#
class appserver (
  $purpose      = "Generic Appserver",
  $colour       = 'blue',
  $number       = '1',
  $size         = 'small',
  $use_template = false,
){

if $use_template {
  file { "/etc/appserver.conf":
    ensure => file,
    content => template('puppet:///appserver/appserver.conf.erb'),
    owner   => 'root',
    group   => 'root',
    seltype => 'etc_t',
    mode    => '644',
    
  }

} else {
  file { "/etc/appserver.conf":
    ensure => file,
    source => [
      "puppet:///modules/appserver/$fqdn/appserver.conf",
      "puppet:///modules/appserver/$hostname/appserver.conf",
      "puppet:///modules/appserver/$domain/appserver.conf",
      "puppet:///modules/appserver/$operatingsystem/appserver.conf",
      "puppet:///modules/appserver/appserver.conf"
    ],
    owner   => 'root',
    group   => 'root',
    seltype => 'etc_t',
    mode    => '644',
    
  }
}

}
