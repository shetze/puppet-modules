# == Class: docker::config
#
class docker::config (
  $dm_auto_storage_setup       = false,
) {
  file { '/etc/sysconfig/docker':
    ensure  => present,
    force   => true,
    content => template("${module_name}/etc/sysconfig/docker.erb"),
  }

  file { '/etc/sysconfig/docker-network':
    ensure  => present,
    force   => true,
    content => template("${module_name}/etc/sysconfig/docker-network.erb"),
  }

  if $dm_auto_storage_setup {
    file { '/etc/sysconfig/docker-storage-setup':
      ensure  => present,
      force   => true,
      content => template("${module_name}/etc/sysconfig/docker-storage-setup.erb"),
    }
    exec { 'docker-storage-setup':
      require => [ File['/etc/sysconfig/docker-storage-setup'], ],
      command => 'docker-storage-setup',
      unless  => 'lvdisplay | grep -q docker-pool_tmeta',
      path    => [ '/usr/bin/', '/usr/sbin/' ],
    }
  } else {
    file { '/etc/sysconfig/docker-storage':
      ensure  => present,
      force   => true,
      content => template("${module_name}/etc/sysconfig/docker-storage.erb"),
    }
  }
}
