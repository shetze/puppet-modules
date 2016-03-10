define git::server::hammer (
  $hammer_user   = 'admin',
  $hammer_passwd = 'akwBhTQ8uBytPcUs',
  $git_repobase  = '/srv/git'
) {

  ensure_packages(['rubygem-hammer_cli_katello',])

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
    require => [ Package['rubygem-hammer_cli_katello'],
      File["${git_repobase}/.hammer/"], ],
  }
}
