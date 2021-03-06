
class buildhost::nexus {

  user { 'nexus':
    name    => 'nexus',
    system  => true,
    home    => '/opt/sonatype-nexus',
    comment => 'Sonatype Nexus Service'
  }
  package { 'nexus':
    ensure  => 'installed',
    require => User['nexus'],
  }
  file { '/opt/sonatype-work/nexus/conf/':
    ensure  => directory,
    owner   => 'nexus',
    group   => 'nexus',
    mode    => '0755',
    require => Package['nexus'],
  }
  file { '/opt/sonatype-work/nexus/conf/nexus.xml':
    ensure  => file,
    content => template('buildhost/nexus.xml.erb'),
    owner   => 'nexus',
    group   => 'nexus',
    mode    => '0644',
    require => File['/opt/sonatype-work/nexus/conf/'],
  }
  file { '/opt/sonatype-nexus/conf/nexus.env':
    ensure  => file,
    content => template('buildhost/nexus.env.erb'),
    owner   => 'nexus',
    group   => 'nexus',
    mode    => '0644',
    require => Package['nexus'],
  }
  file { '/usr/lib/systemd/system/nexus.service':
    ensure  => file,
    content => template('buildhost/nexus.service.erb'),
    owner   => 'nexus',
    group   => 'nexus',
    mode    => '0644',
  }
  exec { 'firewalld_prepare_nexus':
    require => [ Package['firewalld'], ],
    command => "firewall-cmd --permanent --add-port=8081/tcp &&
                firewall-cmd  --complete-reload",
    unless  => 'firewall-cmd --list-all|grep -q 8081',
    path    => '/usr/bin/',
  }
  service { 'nexus':
    ensure  => 'running',
    enable  => true,
    require => [ Package['nexus'], ],
  }
}
