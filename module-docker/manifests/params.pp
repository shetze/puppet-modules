# == Class: docker::params
#
# Default parameter values for the docker module
#
class docker::params {
  $ensure = 'present'
  $service_state = running
  $service_enable = true
  $service_state_storage = 'stopped'
  $service_enable_storage = false
  # options
  $selinux_enabled = true
  $bind_to = 'unix:///var/run/docker.sock'
  $log_level = 'info'
  $tmp_dir = '/var/tmp'
  $dns = undef
  $dns_search = undef
  $proxy = undef
  $no_proxy = undef
  $add_registry = undef
  $block_registry = undef
  $insecure_registry = undef
  $extra_parameters = undef
  # storage options
  $storage_driver = undef
  $dm_auto_storage_setup = false
  $dm_basesize = undef
  $dm_fs = undef
  $dm_mkfsarg = undef
  $dm_mountopt = undef
  $dm_blocksize = undef
  $dm_loopdatasize = undef
  $dm_loopmetadatasize = undef
  $dm_thinpooldev = undef
  $dm_use_deferred_removal = undef
  $dm_use_deferred_deletion = undef
  # network options
  $bridge = undef
  $iptables = undef
  $ip_masq = undef
  $network_extra_parameters = undef
}
