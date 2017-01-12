# == Class: hypervisor
#
# Simple profile class to install a RHV hypervisor
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
# === Examples
#
#  class { 'hypervisor':
#    iscsi_initiator_name => 'iqn.1994-05.com.redhat:b3eb4a9b5e93',
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

}
