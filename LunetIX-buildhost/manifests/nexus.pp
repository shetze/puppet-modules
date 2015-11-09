
class buildhost::nexus {

  user { 'nexus':
    name => 'nexus',
    system => true,
    home => '/opt/sonatype-nexus',
    comment => 'Sonatype Nexus Service'
  }
  package { "java-1.8.0-openjdk":
   ensure => 'installed',
  }
  package { "nexus":
   ensure => 'installed',
   require => [ User['nexus'], Package['java-1.8.0-openjdk'], ],
  }
  file { '/opt/sonatype-work/nexus/conf/nexus.xml':
    ensure => file,
    content => template("$templates/nexus.xml.erb"),
    owner => 'nexus',
    group => 'nexus',
    mode => "644",
    require => Package['nexus'],
  }
  file { '/opt/sonatype-work/nexus/conf/nexus.env':
    ensure => file,
    content => template("$templates/nexus.env.erb"),
    owner => 'nexus',
    group => 'nexus',
    mode => "644",
    require => Package['nexus'],
  }
  file { '/usr/lib/systemd/system/nexus.service':
    ensure => file,
    content => template("$templates/nexus.service.erb"),
    owner => 'nexus',
    group => 'nexus',
    mode => "644",
  }
  exec { "firewalld_prepare_nexus":
    require => [ Package["firewalld"], ],
    command => "firewall-cmd --permanent --add-port=8081/tcp &&
                firewall-cmd  --complete-reload",
    unless => "firewall-cmd --list-all|grep -q 8081",
    path => "/usr/bin/",
  }
  service { "nexus":
   ensure => 'running',
   enable => true,
   require => [ Package['nexus'], ],
  }


}
