# == Class: hypervisor
#
# Simple profile class to install a RHV hypervisor, optional with gluster HCI
#
# === Parameters
#
# Document parameters here.
#
# [*iscsi_initiator_name*]
#  The iscsi_initiator_name can be used to initialize the iSCSI initiator
#  to replace the identity of an previously existing HV after DR
#
# [*ssh_host_key_sec*]
#   The ssh_host_key_sec can take a RSA secret key string to initialize
#   the SSH host key. This can be useful when replacing a previously
#   existing HV after DR
#
# [*ssh_host_key_pub*]
#   The ssh_host_key_pub can take a RSA public key string to initialize
#   the SSH host key. This can be useful when replacing a previously
#   existing HV after DR
#
# [*cockpit_cert*]
#   String with cert bundle for cockpit SSL encryption.
#
# [*install_cockpit_cert_helper*]
#   Trigger install of simple helper script to create cockpit service certs.
#
# [*deploy_hci*]
#   Trigger deployment of gluster SDN on RHV hypervisor as hyperconverged infrastructure
#   https://access.redhat.com/documentation/en-us/red_hat_hyperconverged_infrastructure/1.0/html/deploying_red_hat_hyperconverged_infrastructure/
#
# [*gluster_network*]
#   The A.B.C part of the gluster network, three hosts get hard coded
#   addresses 20,21 and 22 and names gl0{1,2,3}.$domain
#
# [*gluster_dataalignment*]
#   The dataalignemnt is used to optimize LVM pvcreate for the underlying
#   storage hardware. Look at
#   https://access.redhat.com/documentation/en-us/red_hat_gluster_storage/3.2/html-single/administration_guide/#Brick_Configuration
#   for further information.
#   Defaults to 256K which is the recommended value for JABD.
#
# [*gluster_init*]
#   If set to true, the prepared gluster setup will be initialized. This may
#   only be performed on one of the three gluster hosts in the cluster and it
#   must be performed only once after all three hosts are prepared properly.
#
# [*gluster_partition*]
#   This is the device  / partition (name without /dev/) to hold the LVM storage
#   for the gluster bricks. 
#
# [*gluster_rejoin*]
#   If set to true, the newly prepared gluster node will rejoin an existing cluster
#
# [*gluster_uuid*]
#   gluster_uuid is used to re-integrate a freshly provisioned gluster node as
#   replacement for a previously existing node.
#   This uuid can be obtained with 'gluster peer status' on one of the remaining nodes.
#
# [*gluster_restore_from_node*]
#   the fqdn for one of the remaining nodes must be provided to initiate the sync
#   in gluster_restore_from_node
#
# [*gluster_data_trusted_volid]
#   additional trusted.glusterfs.volume-id FACL values must be provided to allow
#   re-sync of the existing bricks.
#   This FACL values must be obtained from a remaining node with
#   'getfattr -n trusted.glusterfs.volume-id /rhgs/brick0?/*/'
#
# [*gluster_vmstore_trusted_volid*]
#   additional trusted.glusterfs.volume-id FACL values must be provided to
#   allow re-sync of the existing bricks.
#   This FACL values must be obtained from a remaining node with
#   'getfattr -n trusted.glusterfs.volume-id /rhgs/brick0?/*/'
#
# === Examples
#
#  class { 'hypervisor':
#    iscsi_initiator_name => 'iqn.1994-05.com.redhat:b3eb4a9b5e93',
#    deploy_hci => true,
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
class hypervisor (
  $iscsi_initiator_name = undef,
  $ssh_host_key_sec = undef,
  $ssh_host_key_pub = undef,
  $cockpit_cert = undef,
  $install_cockpit_cert_helper = false,
  $deploy_hci = false,
  $gluster_network = '192.168.1',
  $gluster_init = false,
  $gluster_partition = 'sda3',
  $gluster_dataalignment = '256K',
  $gluster_rejoin = false,
  $gluster_uuid = undef,
  $gluster_data_trusted_volid = undef,
  $gluster_vmstore_trusted_volid = undef,
  $gluster_restore_from_node = undef,
  
) {
  include stdlib
  include firewalld

  ensure_packages(['vdsm', 'ovirt-vmconsole-host', 'vdsm-cli', 'qemu-kvm-tools-rhev', 'vim-enhanced', 'iscsi-initiator-utils', ])

  if $iscsi_initiator_name {
    file { '/etc/iscsi/initiatorname.iscsi':
      ensure  => file,
      content => template('hypervisor/initiatorname.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      require => Package['iscsi-initiator-utils'],
    }
  }

  if $ssh_host_key_sec {
    include ssh
    ssh::server::host_key {'ssh_host_rsa_key':
      private_key_content => $ssh_host_key_sec,
      public_key_content  => $ssh_host_key_pub,
    }
  }

  # 2223 ssh to VM console
  # 5989 CIM Manager
  # 16514 libvirt VM migration
  firewalld::custom_service{'hypervisor':
    short => 'hypervisor',
    port  => [
      {
        'port' => '2223',
        'protocol' => 'tcp',
      },
      {
        'port' => '5989',
        'protocol' => 'udp',
      },
      {
        'port' => '16514',
        'protocol' => 'tcp',
      },
    ],
  }

  firewalld_service { 'hypervisor':
    ensure  => 'present',
    service => 'hypervisor',
    zone    => 'public',
  }
  firewalld_service { 'vdsm':
    ensure  => 'present',
    service => 'vdsm',
    zone    => 'public',
  }

  class { '::cockpit':
    cockpit_cert => $cockpit_cert,
    install_cockpit_cert_helper => $install_cockpit_cert_helper,
  }

  if $deploy_hci {
    class { '::gluster':
      gluster_cpu_quota => '200%',
      gluster_network => $gluster_network,
      gluster_init => $gluster_init,
      gluster_partition => $gluster_partition,
      gluster_dataalignment => $gluster_dataalignment,
      gluster_pool_size => '200G',
      gluster_pool_metadatasize => '2G',
      gluster_data_brick_size => '150G',
      gluster_vmstore_brick_size => '150G',
    }
    if $gluster_rejoin {
      class { '::gluster::rejoin':
        gluster_data_trusted_volid => $gluster_data_trusted_volid,
        gluster_vmstore_trusted_volid => $gluster_vmstore_trusted_volid,
        gluster_uuid => $gluster_uuid,
        gluster_restore_from_node => $gluster_restore_from_node,
        gluster_op_version => '30712',
      }
    }
  }

}
