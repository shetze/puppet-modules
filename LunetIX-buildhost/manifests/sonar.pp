
class buildhost::sonar {

  user { 'sonar':
    name => 'sonar',
    system => true,
    home => '/opt/sonarqube',
    comment => 'Sonarqube Sonar Service'
  }
  package { "sonarqube":
   ensure => 'installed',
   require => [ User['sonar'], Package['java-1.8.0-openjdk'], ],
  }
  file { '/opt/sonarqube/conf/sonar.properties':
    ensure => file,
    content => template("buildhost/sonar.properties.erb"),
    owner => 'sonar',
    group => 'sonar',
    mode => "644",
    require => Package['sonarqube'],
  }
  file { '/usr/lib/systemd/system/sonar.service':
    ensure => file,
    content => template("buildhost/sonar.service.erb"),
    owner => 'sonar',
    group => 'sonar',
    mode => "644",
  }
  exec { "firewalld_prepare_sonar":
    require => [ Package["firewalld"], ],
    command => "firewall-cmd --permanent --add-port=9000/tcp &&
                firewall-cmd  --complete-reload",
    unless => "firewall-cmd --list-all|grep -q 9000",
    path => "/usr/bin/",
  }


  class { '::postgresql::server':
    ip_mask_allow_all_users => '0.0.0.0/0',
    listen_addresses        => $listen_addresses,
  }
  postgresql::server::db { 'sonar':
    user     => 'sonar',
    password => 'sonar',
    grant    => 'all',
  }


  service { "sonar":
   ensure => 'running',
   enable => true,
   require => [ Package['sonarqube'], Exec['firewalld_prepare_sonar'], File['/usr/lib/systemd/system/sonar.service'], File['/opt/sonarqube/conf/sonar.properties'] ],
  }


}
