# == Class: cockpit
#
# This is a simple module to install the cockpit service on a RHEL system.
# For further information about cockpit, see http://cockpit-project.org/
#
# === Parameters
#
#
# [*cockpit_cert*]
#   You may want to use this parameter to avoid adding security exceptions for
#   every cockpit connection you initiate via your browser.
#   The cockpit_cert may pass a string containing a valid signed SSL certificate
#   and key as concatenated bundle (key is last).  Look at
#   http://cockpit-project.org/guide/latest/https.html
#   for details
#   This cert is installed as /etc/cockpit/ws-certs.d/50-cockpit-service.cert
#
# [*install_cockpit_cert_helper*]
#   If this is parameter is set to true a small script is installed that may
#   help you create SSL service certificates for cockpit. You will find the
#   script at /root/cockpit-cert-helper.sh.
#   The script requires an IPA server to work with.
#
# === Authors
#
# Sebastian Hetze <shetze@redhat.com>
#
# === Copyright
#
# Copyright 2017 Sebastian Hetze
#
class cockpit (
  $cockpit_cert                = undef,
  $install_cockpit_cert_helper = false,
) {
  include stdlib
  include firewalld

  ensure_packages(['cockpit', ])

  firewalld::custom_service{'cockpit':
    short => 'cockpit',
    port  => [
      {
        'port' => '9090',
        'protocol' => 'tcp',
      }
    ],
  }

  firewalld_service { 'allow cockpit access':
    ensure  => 'present',
    service => 'cockpit',
    zone    => 'public',
  }

  service { 'cockpit.socket':
    require => [ Package['cockpit'], ],
    ensure  => 'running',
    enable  => true,
  }

  if $cockpit_cert {
    file { '/etc/cockpit/ws-certs.d/50-cockpit-service.cert':
      content => $cockpit_cert,
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0600',
      require => Package['cockpit'],
    }
  }

  if $install_cockpit_cert_helper {
    ensure_packages(['ipa-admintools', 'dos2unix', ])
    file { '/root/cockpit-cert-helper.sh':
      ensure  => file,
      content => template('cockpit/cert-helper.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      require => Package['ipa-admintools'],
    }
  }


}
