class buildhost::git (
  $jenkins_ssh_pub_key = '',
  $jenkins_user = 'jenkins',
) {

  class{ '::git::server': git_puppet_project => 'puppet-modules' }
  git::server::allow { 'jenkins':
    public_key => $jenkins_ssh_pub_key,
    allow_user => $jenkins_user,
  }
  git::server::createrepo { 'git': git_repo => 'module-git' }
  git::server::createrepo { 'buildhost': git_repo => 'profile-buildhost' }
  git::server::createrepo { 'dockerhost': git_repo => 'profile-dockerhost' }

}
