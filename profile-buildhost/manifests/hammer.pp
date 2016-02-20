class buildhost::hammer (
  $hammer_user = admin,
  $hammer_passwd = 'OhjahNg2',
) {

  package { 'rubygem-hammer_cli':
    ensure => 'installed',
  }

  file { '/var/lib/jenkins/.hammer/':
    ensure => directory,
    group  => 'jenkins',
    mode   => '0700',
  }
  file { '/var/lib/jenkins/.hammer/cli_config.yml':
    ensure  => file,
    content => template('buildhost/hammer-cli_config.yml.erb'),
    group   => 'jenkins',
    mode    => '0600',
    require => [ Package['rubygem-hammer_cli'],
      File['/var/lib/jenkins/.hammer/'], ],
  }
}