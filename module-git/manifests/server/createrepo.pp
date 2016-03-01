define git::server::createrepo (
  $git_repo = undef,
  $git_repobase =  '/srv/git',
  $git_user = 'git',
  $git_group = 'git',
  $git_package = 'git',
  $git_puppet_project = 'puppet-modules',
  $git_post_receive = undef,
  $git_sync_product = 'LunetIX',
  $git_sync_repo = 'LunetIX Puppet Modules',
  $git_sync_cv = 'puppet-library',
){
  exec { "git_init_${git_repo}":
    command => "git init --bare ${git_repobase}/${git_repo}.git && chown -R ${git_user}:${git_group} ${git_repobase}/${git_repo}.git",
    path => [ '/bin/', '/usr/bin/' ],
    unless => "test -d ${git_repobase}/${git_repo}.git/objects",
    require => [ Package["$git_package"], File["$git_repobase"], Exec["selinux_prepare_git"] ],
  }

  if $git_post_receive {
    file { "${git_repobase}/${git_repo}.git/hooks/post-receive":
      ensure => file,
      owner => $git_user,
      group => $git_group,
      mode => "755",
      content => template("git/${git_post_receive}.erb"),
      require => Exec["git_init_${git_repo}"],
    }
  }
}
