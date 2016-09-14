# == Class: docker
#
# Module to install an up-to-date version of Docker from package.
#
# === Parameters
#
# [*ensure*]
#   Passed to the docker package.
#   Defaults to present
#
# [*service_state*]
#   Whether you want to docker daemon to start up
#   Defaults to running
#
# [*service_enable*]
#   Whether you want to docker daemon to start up at boot
#   Defaults to true
#
# [*service_state_storage*]
#   Whether you want to docker storage daemon to start up
#   Defaults to stopped
#
# [*service_enable_storage*]
#   Whether you want to docker storage daemon to start up at boot
#   Defaults to false
#
# [*selinux_enabled*]
#   Enable selinux support. Default is false. SELinux does  not  presently
#   support  the  BTRFS storage driver.
#   Valid values: true, false
#
# [*bind_to*]
#   Where to bind the daemon: unix:///var/run/docker.sock, or 0.0.0.0:2375
#
# [*log_level*]
#   Set the logging level
#   Defaults to undef: docker defaults to info if no value specified
#   Valid values: debug, info, warn, error, fatal
#
# [*dns*]
#   Custom dns server address
#   Defaults to undefined
#
# [*dns_search*]
#   Custom dns search domains
#   Defaults to undefined
#   Type: Array
#
# [*add_registry*]
#   If you want to add your own registry to be used for docker search and docker
#   pull. The first registry added will be the first registry searched.
#   Defaults to undefined
#   Type: Array
#
# [*block_registry*]
#   If you want to block registries from being used give it a set of registries
#   Defaults to undefined
#   Type: Array
#
# [*insecure_registry*]
#   If you have a registry secured with https but do not have proper certs
#   distributed, you can tell docker to not look for full authorization.
#   Defaults to undefined
#   Type: Array
#
# [*proxy*]
#   Will set the http_proxy and https_proxy env variables in /etc/sysconfig/docker (redhat/centos) or /etc/default/docker (debian)
#
# [*no_proxy*]
#   Will set the no_proxy variable in /etc/sysconfig/docker (redhat/centos) or /etc/default/docker (debian)
#
# [*extra_parameters*]
#   Any extra parameters that should be passed to the docker daemon.
#   Defaults to undefined
#
# [*storage_driver*]
#   Specify a storage driver to use
#   Default is undef: let docker choose the correct one
#   Valid values: aufs, devicemapper, btrfs, overlayfs, vfs
#
# [*dm_auto_storage_setup*]
#   docker-storage-setup can create a devicemapper pool automatically. If you use this option, all other dm_*
#   options are ignored and the docker-storage configuration is created once by the docker-storage-setup.
#
# [*dm_basesize*]
#   The size to use when creating the base device, which limits the size of images and containers.
#   Default value is 10G
#
# [*dm_fs*]
#   The filesystem to use for the base image (xfs or ext4)
#   Defaults to ext4
#
# [*dm_mkfsarg*]
#   Specifies extra mkfs arguments to be used when creating the base device.
#
# [*dm_mountopt*]
#   Specifies extra mount options used when mounting the thin devices.
#
# [*dm_blocksize*]
#   A custom blocksize to use for the thin pool.
#   Default blocksize is 64K.
#   Warning: _DO NOT_ change this parameter after the lvm devices have been initialized.
#
# [*dm_loopdatasize*]
#   Specifies the size to use when creating the loopback file for the "data" device which is used for the thin pool
#   Default size is 100G
#
# [*dm_loopmetadatasize*]
#   Specifies the size to use when creating the loopback file for the "metadata" device which is used for the thin pool
#   Default size is 2G
#
# [*dm_thinpooldev*]
#   Specifies a custom block storage device to use for the thin pool.
#
# [*dm_use_deferred_deletion*]
#   By default, thin pool device deletion is synchronous. This option allows use of deferred device deletion for such
#   devices.
#   Before a container is deleted, the Docker daemon removes any associated devices. If the storage driver can not
#   remove a device, the container deletion fails and daemon returns an error.
#   To avoid this failure, enable both deferred device deletion and deferred device removal on the daemon.
#
# [*dm_use_deferred_removal*]
#   If device backing image/container is busy, then docker will not wait for all device refcounts to be dropped.
#   Instead docker will schedule a deferred a deferred removal on device. That is when last reference to
#   device is dropped, kernel will automatically remove the device.
#
# [*bridge*]
#   If you want to take Docker out of the business of creating its own Ethernet bridge entirely, you can set up your
#   own bridge before starting Docker and use --bridge=BRIDGE to tell Docker to use your bridge instead.
#   Can be set to undef, false in order to not be added
#
# [*iptables*]
#   Do your iptables allow this particular connection? Docker will never make changes to your system iptables rules if you
#   set --iptables=false when the daemon starts. Otherwise the Docker server will append forwarding rules to the DOCKER filter chain.
#
# [*ip_masq*]
#   Enable IP masquerading
#
# [*network_extra_parameters*]
#   Any extra parameters that should be passed to the docker daemon from the docker-network script.
#   Available only on redhat clones.
#   Defaults to undefined
#
class docker(
  $ensure                      = $docker::params::ensure,
  $service_state               = $docker::params::service_state,
  $service_enable              = $docker::params::service_enable,
  $service_state_storage       = $docker::params::service_state_storage,
  $service_enable_storage      = $docker::params::service_enable_storage,
  $selinux_enabled             = $docker::params::selinux_enabled,
  $bind_to                     = $docker::params::bind_to,
  $log_level                   = $docker::params::log_level,
  $tmp_dir                     = $docker::params::tmp_dir,
  $dns                         = $docker::params::dns,
  $dns_search                  = $docker::params::dns_search,
  $add_registry                = $docker::params::add_registry,
  $block_registry              = $docker::params::block_registry,
  $insecure_registry           = $docker::params::insecure_registry,
  $extra_parameters            = undef,
  $proxy                       = $docker::params::proxy,
  $no_proxy                    = $docker::params::no_proxy,
  $storage_driver              = $docker::params::storage_driver,
  $dm_auto_storage_setup       = $docker::params::dm_auto_storage_setup,
  $dm_basesize                 = $docker::params::dm_basesize,
  $dm_fs                       = $docker::params::dm_fs,
  $dm_mkfsarg                  = $docker::params::dm_mkfsarg,
  $dm_mountopt                 = $docker::params::dm_mountopt,
  $dm_blocksize                = $docker::params::dm_blocksize,
  $dm_loopdatasize             = $docker::params::dm_loopdatasize,
  $dm_loopmetadatasize         = $docker::params::dm_loopmetadatasize,
  $dm_thinpooldev              = $docker::params::dm_thinpooldev,
  $dm_use_deferred_removal     = $docker::params::dm_use_deferred_removal,
  $dm_use_deferred_deletion    = $docker::params::dm_use_deferred_deletion,
  $bridge                      = $docker::params::bridge,
  $iptables                    = $docker::params::iptables,
  $ip_masq                     = $docker::params::ip_masq,
  $network_extra_parameters    = undef,
) inherits docker::params {
  validate_bool($selinux_enabled)
  validate_absolute_path($tmp_dir)
  validate_string($bind_to)

  if $dns_search {
    validate_array($dns_search)
  }

  if $insecure_registry {
    validate_array($insecure_registry)
  }
  if $add_registry {
    validate_array($add_registry)
  }

  if $block_registry {
    validate_array($block_registry)
  }

  if $tmp_dir {
    validate_absolute_path($tmp_dir)
  }

  if $log_level {
    validate_re($log_level, '^(debug|info|warn|error|fatal)$', 'log_level must be one of debug, info, warn, error or fatal')
  }

  if $storage_driver {
    validate_re($storage_driver, '^(aufs|devicemapper|btrfs|overlay|vfs)$', 'Valid values for storage_driver are aufs, devicemapper, btrfs, overlayfs, vfs.'
    )
  }

  if $dm_auto_storage_setup {
    validate_bool($dm_auto_storage_setup)
    validate_re($storage_driver, '^(devicemapper)$', 'auto_storage_setup only works with storage_driver devicemapper.')
  }
  if $dm_fs {
    validate_re($dm_fs, '^(ext4|xfs)$', 'Only ext4 and xfs are supported currently for dm_fs.')
  }

  class { 'docker::install': } ->
  class { 'docker::config': 
    dm_auto_storage_setup => $dm_auto_storage_setup,
  } ~>
  class { 'docker::service': }
  contain 'docker::install'
  contain 'docker::config'
  contain 'docker::service'

  # Only bother trying extra docker stuff after docker has been installed,
  # and is running.
  Class['docker'] -> Docker::Registry <| |>
  Class['docker'] -> Docker::Image <| |>
}
