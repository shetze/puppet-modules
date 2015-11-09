
class buildhost::mock {

  package { "mock":
   ensure => 'installed',
   require => [ ],
  }
  file { '/etc/mock/site-defaults.cfg':
    ensure => file,
    content => template("$templates/mock-site-defaults.cfg.erb"),
    group => 'mock',
    mode => "644",
    require => Package['mock'],
  }
  file { '/etc/mock/rhel-6-x86_64.cfg':
    ensure => file,
    content => template("$templates/mock-rhel-6-x86_64.cfg.erb"),
    group => 'mock',
    mode => "644",
    require => Package['mock'],
  }
  file { '/etc/mock/rhel-7-x86_64.cfg':
    ensure => file,
    content => template("$templates/mock-rhel-7-x86_64.cfg.erb"),
    group => 'mock',
    mode => "644",
    require => Package['mock'],
  }

}
