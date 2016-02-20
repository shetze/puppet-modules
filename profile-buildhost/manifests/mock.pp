class buildhost::mock (
  $mock_entitlement_path = '/etc/pki/entitlement',
  $mock_rhel6_repos = '',
  $mock_rhel7_repos = '',
) {

  package { 'mock':
    ensure  => 'installed',
    require => [ ],
  }
  file { '/etc/mock/site-defaults.cfg':
    ensure  => file,
    content => template('buildhost/mock-site-defaults.cfg.erb'),
    group   => 'mock',
    mode    => '0644',
    require => Package['mock'],
  }
  file { '/etc/mock/rhel-6-x86_64.cfg':
    ensure  => file,
    content => template('buildhost/mock-rhel-6-x86_64.cfg.erb'),
    group   => 'mock',
    mode    => '0644',
    require => Package['mock'],
  }
  file { '/etc/mock/rhel-7-x86_64.cfg':
    ensure  => file,
    content => template('buildhost/mock-rhel-7-x86_64.cfg.erb'),
    group   => 'mock',
    mode    => '0644',
    require => Package['mock'],
  }

}
