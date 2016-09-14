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
){

class { 'docker':
  bind_to      => "unix:///var/run/docker.sock",
  add_registry => $registries,
  insecure_registry => $insecure_registries,
  storage_driver => 'devicemapper',
  dm_auto_storage_setup => true,
}

ensure_packages( ['atomic-openshift-utils', 'wget', 'git', 'net-tools', 'yum-utils', 'bind-utils', 'iptables-services', 'bridge-utils', 'bash-completion', ] )

}
