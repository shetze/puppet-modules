# == Class: oscp
#
# ocsp is a profile class to prepare a system to become member of a OpenShift cluster.
# In particular, the profile prepares the docker server and storage-pool to meet the prerequisites for OpenShift.
#
# === Parameters
#
#
# [*registries*]
#   Array, defaults to 'registry.access.redhat.com' and may be extended with any secure docker registries you want to include in your OpenShift setup.
#   For OpenShift, you should keep the Red Hat registriy in the list.
#
# [*insecure_registries*]
#   Array, defaults to '172.30.0.0/16' which is the default address range for OpenShift internal regisries. You may change this to reflect your OpenShift network setup.
#
# [*basesize*]
#   Maximum size for base image allowed to load by docker, defaults to 50GB.
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
  $registries          = [ 'registry.access.redhat.com', ],
  $insecure_registries = [ '172.30.0.0/16', ],
  $basesize            = '50GB',
  $ssh_host_key_sec = undef,
  $ssh_host_key_pub = undef,
){

ensure_packages( ['atomic-openshift-utils', 'wget', 'git', 'net-tools', 'yum-utils', 'bind-utils', 'iptables-services', 'bridge-utils', 'bash-completion', 'kexec-tools', 'sos', 'psacct', 'vim-enhanced', 'less', 'atomic-openshift-excluder', 'atomic-openshift-docker-excluder' ] )

exec { 'unexclude_once':
  command => "atomic-openshift-excluder unexclude",
  creates  => "/root/.unexclude_done",
  path    => [ "/usr/bin/", "/usr/sbin/" ],
  require => [ Package["atomic-openshift-excluder"] ],
  before  => File['/root/.unexclude_done'],
}

file { '/root/.unexclude_done':
  ensure  => file,
}

file { "/etc/ansible/hosts":
  ensure  => file,
  content => template('oscp/hosts.erb'),
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
}

class { 'docker':
  bind_to      => "unix:///var/run/docker.sock",
  add_registry => $registries,
  insecure_registry => $insecure_registries,
  storage_driver => 'devicemapper',
  dm_auto_storage_setup => true,
  dm_basesize => $basesize,
}

if $ssh_host_key_sec {
  # include ssh
  ssh::server::host_key {'ssh_host_rsa_key':
    private_key_content => $ssh_host_key_sec,
      public_key_content  => $ssh_host_key_pub,
  }
}

}
