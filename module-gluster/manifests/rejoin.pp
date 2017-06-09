# == Class: gluster::rejoin
class gluster::rejoin (
  $gluster_data_trusted_volid = undef,
  $gluster_vmstore_trusted_volid = undef,
  $gluster_restore_from_node = undef,
  $gluster_uuid = undef,
  $gluster_op_version = '30712',
) {

  include stdlib

  # gluster_uuid is used to re-integrate a freshly provisioned gluster node as replacement for a previously existing node.
  # this uuid can be obtained with 'gluster peer status' on one of the remaining nodes.
  # additional trusted.glusterfs.volume-id FACL values must be provided to allow re-sync of the existing bricks
  # this FACL values must be obtained from a remaining node with 'getfattr -n trusted.glusterfs.volume-id /rhgs/brick0?/*/'
  # last, the fqdn for one of the remaining nodes must be provided to initiate the sync in gluster_restore_from_node
  file { '/var/lib/glusterd/glusterd.info':
    require => [ Exec['prepare_glusterd'], ],
    ensure  => file,
    content => template('gluster/glusterd-info.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
  }
  exec { 'setfacl_vmstore':
    require => [ Exec['prepare_glusterd'], ],
    command => "setfattr -n trusted.glusterfs.volume-id -v $gluster_vmstore_trusted_volid /rhgs/brick01/vmstore/",
    unless  => "getfattr -n trusted.glusterfs.volume-id /rhgs/brick01/vmstore/|grep -q $gluster_vmstore_trusted_volid",
    path    => [ '/usr/sbin/','/usr/bin/', ],
  }
  exec { 'setfacl_data':
    require => [ Exec['prepare_glusterd'], ],
    command => "setfattr -n trusted.glusterfs.volume-id -v $gluster_data_trusted_volid /rhgs/brick02/data/",
    unless  => "getfattr -n trusted.glusterfs.volume-id /rhgs/brick02/data/|grep -q $gluster_data_trusted_volid",
    path    => [ '/usr/sbin/','/usr/bin/', ],
  }
  exec { 'rejoin_cluster':
    require => [ Exec['setfacl_vmstore','setfacl_data'], File['/var/lib/glusterd/glusterd.info']],
    command => "systemctl restart glusterd &&
                gluster peer probe gl01.$domain &&
                gluster peer probe gl02.$domain &&
                gluster peer probe gl03.$domain &&
                systemctl restart glusterd &&
                touch /root/gluster_rejoin_done",
    unless  => "/usr/bin/test -f /root/gluster_rejoin_done",
    path    => [ '/usr/sbin/','/usr/bin/', ],
  }
  if $gluster_restore_from_node {
    exec { 'heal_cluster':
      require => [ Exec['rejoin_cluster'] ],
      command => "echo y|gluster volume sync $gluster_restore_from_node all &&
                  gluster volume heal data full &&
		  gluster volume heal vmstore full &&
		  touch /root/gluster_restore_done",
      unless  => "/usr/bin/test -f /root/gluster_restore_done",
      path    => [ '/usr/sbin/','/usr/bin/', ],
    }
  }
}
