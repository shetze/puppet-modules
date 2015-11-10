class buildhost::hammer {

  package { "rubygem-hammer_cli":
   ensure => 'installed',
  }

  file { '/var/lib/jenkins/.hammer/':
    ensure => directory,
    group => 'jenkins',
    mode => "700",
  }
  file { '/var/lib/jenkins/.hammer/cli_config.yml':
    ensure => file,
    content => template("buildhost/hammer-cli_config.yml.erb"),
    group => 'jenkins',
    mode => "600",
    require => [ Package['rubygem-hammer_cli'], File['/var/lib/jenkins/.hammer/'], ],
  }

}
