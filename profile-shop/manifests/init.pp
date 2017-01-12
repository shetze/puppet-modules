# == Class: shop
#
# The shop class takes the oxid subclass to create a OXID shop instance.
# The class by default does instantiate a mariadb DB using the
# puppetforge mysql module.
#
# === Parameters
#
# Document parameters here.
#
# [*install_db*]
#   Default is true, which make the module install mariadb and create a
#   database for OXID.
#
# [*shop_db_name*]
#   The name of the OXID database, defaults to 'oxid'.
#
# [*shop_db_user*]
#   The DB user name to acces the shop database, defaults to 'oxid'.
#
# [*shop_db_pass*]
#   The DB user credential to access the shop database, defaults to 'Geheim!!'
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'shop':
#    shop_db_pass => 'EaphiW1I',
#  }
#
# === Authors
#
# Author Name <shetze@redhat.com>
#
# === Copyright
#
# Copyright 2016 Sebastian Hetze
#
class shop (
  $install_db   = true,
  $shop_db_name = 'oxid',
  $shop_db_user = 'oxid',
  $shop_db_pass = 'Geheim!!',
) {

  if $install_db {
    class { '::mysql::server':
      package_name            => 'mariadb-server',
      service_name            => 'mariadb',
      root_password           => 'DooK1ieG',
      remove_default_accounts => true,
      override_options => {
        mysqld => {
          'log-error' => '/var/log/mariadb/mariadb.log',
          'pid-file'  => '/var/run/mariadb/mariadb.pid',
        },
        mysqld_safe => {
          'log-error' => '/var/log/mariadb/mariadb.log',
        },
      }
    }

    mysql::db { $shop_db_name:
      user     => $shop_db_user,
      password => $shop_db_pass,
      host     => 'localhost',
      grant    => ['ALL',],
    }
  }

  include shop::oxid

}
