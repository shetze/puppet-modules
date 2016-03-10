class buildhost::mock (
  $mock_entitlement_path = '/etc/pki/entitlement',
  $mock_extra_packages   = '',
) {
  package { 'mock':
    ensure  => 'installed',
  }
  file { '/etc/mock/site-defaults.cfg':
    ensure  => file,
    content => template('buildhost/mock-site-defaults.cfg.erb'),
    group   => 'mock',
    mode    => '0644',
    require => Package['mock'],
  }
  concat { '/etc/mock/rhel-7-x86_64.cfg':
    group   => 'mock',
    mode    => '0644',
    require => Package['mock'],
  }
  concat::fragment { 'rhel-7-x86_64_header':
    target  => '/etc/mock/rhel-7-x86_64.cfg',
    content => template('buildhost/mock-rhel-7-x86_64.cfg.erb'),
    order   => '01',
  }
  concat::fragment { 'rhel-7-x86_64_redhat_repos':
    target => '/etc/mock/rhel-7-x86_64.cfg',
    source => '/etc/yum.repos.d/redhat.repo',
    order  => '02',
  }
  concat::fragment { 'rhel-7-x86_64_end':
    target  => '/etc/mock/rhel-7-x86_64.cfg',
    content => '"""',
    order   => '10',
  }

}
