define git::server::createrepo (
  $git_repo = undef,
  $git_repobase =  '/srv/git',
  $git_user = 'git',
  $git_group = 'git',
  $git_package = 'git',
){
exec { "git_init_${git_repo}":
    command => "git init --bare ${git_repobase}/${git_repo}.git && chown -R ${gituser}:${gitgroup} ${git_repobase}/${git_repo}.git",
    path => [ '/bin/', '/usr/bin/' ],
    unless => "test -d ${git_repobase}/${git_repo}.git/objects",
    require => [ Package["$git_package"], File["$git_repobase"], Exec["selinux_prepare_git"] ],
    before => File["${git_repobase}/${git_repo}.git/hooks/post-receive"],
}

file { "${git_repobase}/${git_repo}.git/hooks/post-receive":
    ensure => file,
    owner => $gituser,
    group => $gitgroup,
    mode => "755",
    content => template('git/post-receive.erb'),
}

}
