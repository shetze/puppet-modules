# == Class: gluster
#
# This simple module installs and configures a gluster storage service on a RHEL system.
# The setup follows the architecture described in https://access.redhat.com/articles/2578391.
# The underlying LVM storage for the gluster bricks is created on a empty partition (gluster_partition)
# The pvcreate uses gluster_dataalignment for optimization.
# Two bricks, data and vmstore will be created.
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
# [*gluster_cpu_quota*]
#   cgroup limit for CPU usage of gluster daemon, defaults to 200%
#
# [*gluster_network*]
#   The A.B.C part of the gluster network, three hosts get hard coded
#   addresses 20,21 and 22 and names gl0{1,2,3}.$domain
#
# [*gluster_init*]
#   If set to true, the prepared gluster setup will be initialized. This may
#   only be performed on one of the three gluster hosts in the cluster and it
#   must be performed only once after all three hosts are prepared properly.
#
# [*gluster_partition*]
#   This is the device / partition to hold the LVM storage for the gluster
#   bricks.
#
# [*gluster_dataalignment*]
#   The dataalignemnt is used to optimize LVM pvcreate for the underlying
#   storage hardware. Look at
#   https://access.redhat.com/documentation/en-US/Red_Hat_Storage/3.1/html-single/Administration_Guide/index.html#Brick_Configuration
#   for further information.
#   Defaults to 256K which is the recommended value for JABD.
#
# [*gluster_pool_size*]
#   This is the pool size to hold the thin provisioned volumes.
#
# [*gluster_pool_metadatasize*]
#   The metadatssize should be at at least 0.5% of the pool size and 16G at max.
#
# [*gluster_data_brick_size*]
#   The size of the thin provisioned data brick.
#
# [*gluster_vmstore_brick_size*]
#   The size of the thin provisioned vmstore brick.
#
#
#
# === Examples
#
#  class { 'gluster':
#    gluster_partition => 'sda3',
#    gluster_network   => '192.168.5',
#  }
#
# === Authors
#
# Sebastian Hetze <shetze@redhat.com>
#
# === Copyright
#
# Copyright 2017 Sebastian Hetze
#
class gluster (
  $gluster_cpu_quota = '200%',
  $gluster_network = '192.168.1',
  $gluster_init = false,
  $gluster_partition = 'sda3',
  $gluster_dataalignment = '256K',
  $gluster_pool_size = '200G',
  $gluster_pool_metadatasize = '2G',
  $gluster_data_brick_size = '150G',
  $gluster_vmstore_brick_size = '150G',
) {
  include stdlib
  include firewalld

  ensure_packages(['ansible', 'gdeploy', 'vdsm-gluster', 'gluster-nagios-addons', ])

  service { 'glusterd':
    ensure  => 'running',
    enable  => true,
  }

  firewalld::custom_service{'hci':
    short => 'hci',
    port  => [
      {
        'port' => '111',
        'protocol' => 'tcp',
      },
      {
        'port' => '2049',
        'protocol' => 'tcp',
      },
    ],
  }

  firewalld_service { 'hci':
    ensure  => 'present',
    service => 'hci',
    zone    => 'public',
  }
  firewalld_service { 'glusterfs':
    ensure  => 'present',
    service => 'glusterfs',
    zone    => 'public',
  }

  file { '/root/gluster-setup.sh':
    ensure  => file,
    content => template('gluster/gluster-setup.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

  file { '/root/gluster-init.sh':
    ensure  => file,
    content => template('gluster/gluster-init.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

  exec { 'prepare_glusterd':
    require => [ File['/root/gluster-setup.sh'], ],
    command => "/bin/bash /root/gluster-setup.sh",
    unless  => 'grep -q /rhgs/brick01 /etc/fstab',
    path    => [ '/usr/sbin/','/usr/bin/', ],
  }

  if $gluster_init {
    exec { 'init_glusterd':
      require => [ Exec['prepare_glusterd'], File['/root/gluster-init.sh'], ],
      command => "/bin/bash /root/gluster-init.sh",
      unless  => 'gluster peer status|grep -q "Number of Peers: 2"',
      path    => [ '/usr/sbin/','/usr/bin/', ],
    }
  }
}
