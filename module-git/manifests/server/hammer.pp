class git::server::hammer (
  $hammer_user = admin,
  $hammer_passwd = 'akwBhTQ8uBytPcUs',
  $git_repobase =  '/srv/git'
  $rhsm_organization_label = 'ACME'
  $foreman_url = 'satellite.acme.org'
) {

  package { 'rubygem-hammer_cli_katello':
    ensure => 'installed',
  }

  file { "${git_repobase}/.hammer/":
    ensure => directory,
    owner  => 'git',
    group  => 'git',
    mode   => '0700',
  }
  file { "${git_repobase}/.hammer/cli_config.yml":
    ensure  => file,
    content => template('git/hammer-cli_config.yml.erb'),
    owner   => 'git',
    group   => 'git',
    mode    => '0600',
    require => [ Package['rubygem-hammer_cli'],
      File["${git_repobase}/.hammer/"], ],
  }
}
