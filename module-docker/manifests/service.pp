# == Class: docker::service
#
# Class to manage the docker service daemon
#
class docker::service {
  service { 'docker-storage-setup':
    ensure => $docker::service_state_storage,
    enable => $docker::service_enable_storage,
  }

  service { 'docker':
    ensure => $docker::service_state,
    enable => $docker::service_enable,
  }
}
