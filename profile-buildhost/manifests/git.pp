class buildhost::git (
  $jenkins_ssh_pub_key = '',
  $jenkins_user = 'jenkins',
  $git_puppet_project = 'puppet-modules',
  $git_repobase =  '/srv/git',
  $git_host = 'localhost',
  $git_user = 'git',
  $git_group = 'git',
  $hammer_user = 'admin',
  $hammer_passwd = 'akwBhTQ8uBytPcUs'
) {

  class{ '::git::server': git_puppet_project => 'puppet-modules' }
  git::server::allow { 'jenkins':
    public_key => $jenkins_ssh_pub_key,
    allow_user => $jenkins_user,
  }
  git::server::hammer { 'git_hammer': hammer_user => $hammer_user, hammer_passwd => $hammer_passwd, git_repobase =>  $git_repobase }
  git::server::createrepo { 'git': git_repo => 'module-git', git_post_receive => 'puppet-post-receive' }
  git::server::createrepo { 'buildhost': git_repo => 'profile-buildhost', git_post_receive => 'puppet-post-receive' }
  git::server::createrepo { 'control': git_repo => 'control-buildhost' }
  git::server::createrepo { 'dockerhost': git_repo => 'profile-dockerhost', git_post_receive => 'puppet-post-receive' }
  git::server::createrepo { 'packages': git_repo => 'buildhost-packages' }
  git::server::createrepo { 'ticketmonster': git_repo => 'ticket-monster' }

  file { "/root/gitloader.sh":
    ensure  => file,
    content => template('buildhost/gitloader.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

}
