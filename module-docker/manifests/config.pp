# == Class: docker::config
#
class docker::config {
  file { '/etc/sysconfig/docker':
    ensure  => present,
    force   => true,
    content => template("${module_name}/etc/sysconfig/docker.erb"),
  }

  file { '/etc/sysconfig/docker-storage':
    ensure  => present,
    force   => true,
    content => template("${module_name}/etc/sysconfig/docker-storage.erb"),
  }

  file { '/etc/sysconfig/docker-network':
    ensure  => present,
    force   => true,
    content => template("${module_name}/etc/sysconfig/docker-network.erb"),
  }

  file { '/etc/sysconfig/docker-storage-setup':
    ensure  => present,
    force   => true,
    content => template("${module_name}/etc/sysconfig/docker-storage-setup.erb"),
  }
}
