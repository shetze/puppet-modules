class buildhost::jenkins (
  $jenkins_ssh_priv_key  = '',
  $maven_package_ensure  = 'installed',
  $git_repobase          = '/srv/git',
  $create_jenkins_repo   = false,
  $deploy_demo           = false,
  $ci_yum_repo_id        = 160,
  $ci_puppet_repo_id     = 190,
  $ci_target_env         = 1,
  $ci_content_view       = 'bl-dev-rhel7',
  $ci_template_instance  = 'rhel7-baseline.lunetix.org',
  $ci_git_host           = 'bx-builder.lunetix.org',
  $ci_build_host         = 'bx-bld-dev01.lunetix.org',
  $ci_dockerhost_test    = 'bx-dh01.lunetix.org',
  $ci_dockerhost_prod    = 'bx-dh01.lunetix.org',
  $deploy_ci_pipeline    = true,
  $mock_entitlement_path = '/etc/pki/entitlement',
  $mock_extra_packages   = '',
  $sonar_database_host   = 'localhost',
) {
  include stdlib
  include jenkins
  class{ '::jenkins': repo => $create_jenkins_repo }
  jenkins::plugin { 'scm-api': }
  jenkins::plugin { 'git-client': }
  jenkins::plugin { 'git': }
  jenkins::plugin { 'mapdb-api': }
  jenkins::plugin { 'multiple-scms': }
  jenkins::plugin { 'tap': }
  jenkins::plugin { 'build-pipeline-plugin': }
  jenkins::plugin { 'jquery': }
  jenkins::plugin { 'parameterized-trigger': }
  jenkins::plugin { 'sonar': }

  file { '/var/lib/jenkins/.ssh/':
    ensure  => directory,
    owner   => jenkins,
    group   => jenkins,
    mode    => '0700',
    content => template('buildhost/id-rsa.erb'),
    require => Package['jenkins'],
  }

  file { '/var/lib/jenkins/.ssh/id_rsa':
    owner   => jenkins,
    group   => jenkins,
    mode    => '0400',
    content => template('buildhost/id-rsa.erb'),
    require => [ Package['jenkins'], File['/var/lib/jenkins/.ssh/'] ],
  }

  exec { 'jenkins_know_githost':
    command => "/usr/bin/ssh-keyscan -t rsa ${ci_git_host} >> /var/lib/jenkins/.ssh/known_hosts",
    unless  => "grep -q ${ci_git_host} /var/lib/jenkins/.ssh/known_hosts",
    path    => [ '/usr/bin/', '/usr/sbin/' ],
    require => Package['jenkins'],
  }

  file { '/var/lib/jenkins/.ssh/known_hosts':
    require => [ Exec['jenkins_know_githost'], ],
    owner   => jenkins,
    group   => jenkins,
    mode    => '0600'
  }

  ensure_packages( ['firewalld','java-1.8.0-openjdk-devel','apache-maven',])

  exec { 'firewalld_prepare_jenkins':
    require => [ Package['firewalld'], ],
    command => "firewall-cmd --permanent --add-port=8080/tcp &&
                firewall-cmd  --complete-reload",
    unless  => 'firewall-cmd --list-all|grep -q 8080',
    path    => '/usr/bin/',
  }

  jenkins::job { 'baseline-template':
    config => template('buildhost/baseline-template.xml.erb'),
  }
  jenkins::job { 'puppet-modules-dev':
    config => template('buildhost/puppet-modules-dev.xml.erb'),
  }
  jenkins::job { 'puppet-modules-prod':
    config => template('buildhost/puppet-modules-prod.xml.erb'),
  }
  jenkins::job { 'baseline-packages-dev':
    config => template('buildhost/baseline-packages-dev.xml.erb'),
  }
  jenkins::job { 'baseline-packages-prod':
    config => template('buildhost/baseline-packages-prod.xml.erb'),
  }

  if $deploy_demo {
    jenkins::job { 'ticket-monster-dev':
      config => template('buildhost/ticket-monster-dev.xml.erb'),
    }
    jenkins::job { 'ticket-monster-sonar':
      config => template('buildhost/ticket-monster-sonar.xml.erb'),
    }
    jenkins::job { 'ticket-monster-systest':
      config => template('buildhost/ticket-monster-systest.xml.erb'),
    }
    jenkins::job { 'ticket-monster-prod':
      config => template('buildhost/ticket-monster-prod.xml.erb'),
    }
  }

  file { '/var/lib/jenkins/hudson.tasks.Maven.xml':
    ensure  => file,
    content => template('buildhost/hudson.tasks.Maven.xml.erb'),
    owner   => 'jenkins',
    group   => 'jenkins',
    mode    => '0644',
    require => [ Package['apache-maven'], Package['jenkins'], ],
  }
  file { '/var/lib/jenkins/maven-settings.xml':
    ensure  => file,
    content => template('buildhost/maven-settings.xml.erb'),
    owner   => 'jenkins',
    group   => 'jenkins',
    mode    => '0644',
    require => [ Package['apache-maven'], Package['jenkins'], ],
  }

  exec { 'jenkins_memberof_mock':
    command => 'groupmems --group mock --add jenkins',
    unless  => 'grep -q "mock:.*jenkins" /etc/group',
    onlyif  => 'grep -q "mock:" /etc/group',
    path    => [ '/usr/bin/', '/usr/sbin/' ],
    require => [ Package['jenkins'], Package['mock'] ],
  }

}
